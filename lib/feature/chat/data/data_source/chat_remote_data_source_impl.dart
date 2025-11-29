import 'dart:async';
import 'package:blood_bank/core/utils/firebase_pathes.dart';
import 'package:blood_bank/feature/chat/data/data_source/chat_remote_data_source.dart';
import 'package:blood_bank/feature/chat/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blood_bank/feature/chat/data/models/message_model.dart';
import 'package:blood_bank/feature/chat/data/models/chat_summary_model.dart';

/// التنفيذ الفعلي لمصدر البيانات عن بعد باستخدام Firebase Firestore.
/// يتم استخدام باتشات الكتابة (Write Batches) لضمان التزامن في إرسال الرسائل وتحديث الملخصات.
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore _firestore;

  ChatRemoteDataSourceImpl(this._firestore);

  // ==========================================================
  // 1. المسارات الأساسية في Firestore
  // ==========================================================

  /// Collection users في الـ Root
  CollectionReference get _usersCollection => _firestore.collection('users');

  /// Collection chats في الـ Root
  /// المسار النهائي: /chats/{chatId}/messages
  CollectionReference get _chatsCollection =>
      _firestore.collection(FirebasePaths.publicCollection('chats'));

  // ==========================================================
  // 2. Streams
  // ==========================================================

  @override
  Stream<List<UserModel>> streamAllUsers() {
    return _usersCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    });
  }

  @override
  Stream<List<ChatSummaryModel>> streamChatSummaries(String currentUserId) {
    // المسار: /users/{userId}/chats
    final userChatsCollection = _firestore.collection(
      FirebasePaths.userPrivateCollection(currentUserId, 'chats'),
    );

    return userChatsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatSummaryModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    });
  }

  @override
  Stream<List<MessageModel>> streamMessages(String chatId) {
    final messagesCollection =
        _chatsCollection.doc(chatId).collection('messages');

    return messagesCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    });
  }

  // ==========================================================
  // 3. Future Reads
  // ==========================================================

  @override
  Future<UserModel> getUser(String userId) async {
    final doc = await _usersCollection.doc(userId).get();

    if (!doc.exists) {
      throw Exception('User with ID $userId not found');
    }

    return UserModel.fromSnapshot(
        doc as DocumentSnapshot<Map<String, dynamic>>);
  }

  // ==========================================================
  // 4. Writes
  // ==========================================================

  @override
  Future<void> sendMessage({
    required String receiverId,
    required String content,
    required String senderId,
    required String chatId,
  }) async {
    final batch = _firestore.batch();
    final timestamp = FieldValue.serverTimestamp();

    // 1. إضافة الرسالة داخل /chats/{chatId}/messages
    final messageDocRef =
        _chatsCollection.doc(chatId).collection('messages').doc();

    final messageData = MessageModel(
      id: messageDocRef.id,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      timestamp: DateTime.now(),
      isRead: false,
    ).toJson()
      ..['timestamp'] = timestamp;

    batch.set(messageDocRef, messageData);

    // 2. تحديث ملخص المحادثة للمرسل
    final senderSummaryRef = _firestore.doc(
      FirebasePaths.userPrivateDoc(senderId, 'chats', receiverId),
    );

    batch.set(senderSummaryRef, {
      'lastMessageContent': content,
      'lastMessageTimestamp': timestamp,
      'unreadCount': 0,
      'isLastMessageReadByMe': true,
      'lastMessageSenderId': senderId,
    });

    // 3. تحديث ملخص المحادثة للمستقبل
    final receiverSummaryRef = _firestore.doc(
      FirebasePaths.userPrivateDoc(receiverId, 'chats', senderId),
    );

    batch.set(
        receiverSummaryRef,
        {
          'lastMessageContent': content,
          'lastMessageTimestamp': timestamp,
          'unreadCount': FieldValue.increment(1),
          'isLastMessageReadByMe': false,
          'lastMessageSenderId': senderId,
        },
        SetOptions(merge: true));

    await batch.commit();
  }

  @override
  Future<void> markMessagesAsRead({
    required String currentUserId,
    required String otherUserId,
  }) async {
    final docRef = _firestore.doc(
      FirebasePaths.userPrivateDoc(currentUserId, 'chats', otherUserId),
    );

    await docRef.update({
      'unreadCount': 0,
    });
  }
}

import 'package:blood_bank/core/error/failures.dart';
import 'package:blood_bank/feature/auth/data/models/user_model.dart';
import 'package:blood_bank/feature/chat/data/models/message_model.dart';
import 'package:blood_bank/feature/chat/data/models/user_chat_model.dart';
import 'package:blood_bank/feature/chat/data/repo/chat_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore firestore;

  ChatRepositoryImpl({required this.firestore});

  // ======================= Get User Data =======================
  @override
  Future<Either<Failure, UserModel>> getUserData(String userId) async {
    try {
      final userDoc = await firestore.collection("users").doc(userId).get();
      if (!userDoc.exists) {
        return Left(ServerFailure("User not found"));
      }
      return Right(UserModel.fromJson(userDoc.data()!));
    } on FirebaseException catch (e) {
      return Left(NetworkFailure(e.message ?? "Network error"));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // ======================= Send Message =======================
  @override
  Future<Either<Failure, void>> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String messageText,
  }) async {
    try {
      final chatDocRef = firestore.collection("chats").doc(chatId);
      final chatDoc = await chatDocRef.get();

      if (!chatDoc.exists) {
        await chatDocRef.set({
          "users": [senderId, receiverId],
          "lastMessage": "",
          "lastMessageTime": FieldValue.serverTimestamp(),
          "lastMessageSeen": true,
          "lastMessageSenderId": "",
        });
      }

      await chatDocRef.collection("messages").add({
        "senderId": senderId,
        "receiverId": receiverId,
        "text": messageText,
        "timestamp": FieldValue.serverTimestamp(),
      });

      await chatDocRef.update({
        "lastMessage": messageText,
        "lastMessageTime": FieldValue.serverTimestamp(),
        "lastMessageSeen": false,
        "lastMessageSenderId": senderId,
      });

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(NetworkFailure(e.message ?? "Network error"));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // ======================= Mark Last Message As Seen =======================
  @override
  Future<Either<Failure, void>> markMessageAsSeen(String chatId) async {
    try {
      final chatDocRef = firestore.collection("chats").doc(chatId);
      final chatDoc = await chatDocRef.get();
      if (!chatDoc.exists) return const Right(null);

      await chatDocRef.update({
        "lastMessageSeen": true,
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(NetworkFailure(e.message ?? "Network error"));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // ======================= Get All Users With Last Message =======================
  @override
  Stream<List<UserChatModel>> getAllUsersWithLastMessageStream(
      String currentUserId) {
    // نسمع جميع المستخدمين
    return firestore
        .collection('users')
        .snapshots()
        .asyncMap((usersSnapshot) async {
      List<UserChatModel> userChats = [];

      for (var doc in usersSnapshot.docs) {
        if (doc.id == currentUserId) continue;

        final userData = doc.data();
        final chatId = generateChatId(currentUserId, doc.id);

        final chatDoc = await firestore.collection('chats').doc(chatId).get();
        final chatData = chatDoc.exists ? chatDoc.data() : null;

        final userChat = UserChatModel.fromData(
          userData: {...userData, "uid": doc.id},
          chatData: chatData,
        );

        userChats.add(userChat);
      }

      // نرتب حسب آخر رسالة
      userChats.sort((a, b) {
        final aTime =
            a.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime =
            b.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });

      return userChats;
    });
  }

  // ======================= Generate Chat ID =======================
  @override
  String generateChatId(String user1Id, String user2Id) {
    return user1Id.compareTo(user2Id) < 0
        ? '${user1Id}_$user2Id'
        : '${user2Id}_$user1Id';
  }

  @override
  Future<Either<Failure, MessageModel?>> getChatData(String chatId) async {
    try {
      final messagesSnapshot = await firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .orderBy("timestamp", descending: true)
          .limit(1)
          .get();

      if (messagesSnapshot.docs.isEmpty) {
        return const Right(null);
      }

      final lastMessageDoc = messagesSnapshot.docs.first;
      final lastMessage = MessageModel.fromMap(lastMessageDoc.data());

      return Right(lastMessage);
    } on FirebaseException catch (e) {
      return Left(NetworkFailure(e.message ?? "Network error"));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageModel>>> getAllMessages(
      String chatId) async {
    try {
      final messagesQuery = await firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .orderBy("timestamp", descending: false)
          .get();

      final messages = messagesQuery.docs
          .map((doc) => MessageModel.fromMap(doc.data()))
          .toList();

      return Right(messages);
    } on FirebaseException catch (e) {
      return Left(NetworkFailure(e.message ?? "Network error"));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}

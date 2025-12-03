import 'package:blood_bank/core/error/failures.dart';
import 'package:blood_bank/feature/auth/data/models/user_model.dart';
import 'package:blood_bank/feature/chat/data/models/message_model.dart';
import 'package:blood_bank/feature/chat/data/models/user_chat_model.dart';
import 'package:blood_bank/feature/chat/data/repo/chat_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';

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
        "isSeen": false,
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
  Future<Either<Failure, void>> markMessageAsSeen(
      String chatId, String currentUserId) async {
    try {
      final messagesRef =
          firestore.collection("chats").doc(chatId).collection("messages");

      final unreadMessages = await messagesRef
          .where("receiverId", isEqualTo: currentUserId)
          .where("isSeen", isEqualTo: false)
          .get();

      for (var msg in unreadMessages.docs) {
        await msg.reference.update({"isSeen": true});
      }

      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

//-------------------get unread count----------------------------------------------
  @override
  Stream<QuerySnapshot> getUnreadMessages({
    required String currentUserId,
    required String otherUserId,
  }) {
    final chatId = generateChatId(currentUserId, otherUserId);
    return FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .where("isSeen", isEqualTo: false)
        .where("receiverId", isEqualTo: currentUserId)
        .snapshots();
  }

  // ======================= Get All Users With Last Message =======================
  @override
  Stream<List<UserChatModel>> getAllUsersWithLastMessageStream(
      String currentUserId) {
    return firestore.collection('users').snapshots().switchMap((usersSnapshot) {
      List<Stream<UserChatModel>> userStreams = [];

      for (var doc in usersSnapshot.docs) {
        if (doc.id == currentUserId) continue;

        final userData = {...doc.data(), "uid": doc.id};
        final chatId = generateChatId(currentUserId, doc.id);

        final chatStream =
            firestore.collection('chats').doc(chatId).snapshots();

        final userChatStream = chatStream.map((chatDoc) {
          return UserChatModel.fromData(
            userData: userData,
            chatData: chatDoc.data(),
          );
        });

        userStreams.add(userChatStream);
      }

      return Rx.combineLatestList(userStreams).map((userChats) {
        final sorted = List<UserChatModel>.from(userChats);

        sorted.sort((a, b) {
          final aTime =
              a.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bTime =
              b.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bTime.compareTo(aTime);
        });

        return sorted;
      });
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
}

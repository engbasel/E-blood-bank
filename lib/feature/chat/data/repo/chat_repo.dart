import 'package:blood_bank/core/error/failures.dart';
import 'package:blood_bank/feature/auth/data/models/user_model.dart';
import 'package:blood_bank/feature/chat/data/models/message_model.dart';
import 'package:blood_bank/feature/chat/data/models/user_chat_model.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepository {
  Future<Either<Failure, UserModel>> getUserData(String userId);

  Future<Either<Failure, void>> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String messageText,
  });
  Future<Either<Failure, MessageModel?>> getChatData(String chatId);
  Future<Either<Failure, void>> markMessageAsSeen(
      String chatId, String currentUserId);
  Stream<int> getUnreadCount(String chatId, String currentUserId);
  Stream<List<UserChatModel>> getAllUsersWithLastMessageStream(
      String currentUserId);

  String generateChatId(String user1Id, String user2Id);
}

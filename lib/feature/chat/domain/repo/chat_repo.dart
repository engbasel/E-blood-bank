import 'package:blood_bank/core/error/failures.dart';
import 'package:blood_bank/feature/auth/domain/entities/user_entity.dart';
import 'package:blood_bank/feature/chat/domain/entities/chat_entity.dart';
import 'package:blood_bank/feature/chat/domain/entities/message_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepository {
  // ==========================================================
  // 1. وظائف قراءة بيانات المستخدمين (لعملية الدمج)
  // ==========================================================

  // يبث قائمة جميع المستخدمين في التطبيق
  Stream<Either<Failure, List<UserEntity>>> streamAllUsers();

  // ==========================================================
  // 2. وظائف قراءة قائمة الدردشة والرسائل
  // ==========================================================

  // يبث قائمة المحادثات المدمجة (ChatEntity) بما في ذلك ملخص آخر رسالة وعداد غير المقروء.
  Stream<Either<Failure, List<ChatEntity>>> streamUserChats(
      String currentUserId);

  // يبث جميع الرسائل في محادثة معينة مرتبة حسب التاريخ.
  Stream<Either<Failure, List<MessageEntity>>> streamMessages(
      String otherUserId);

  // ==========================================================
  // 3. وظائف الكتابة والتحديث
  // ==========================================================

  // إرسال رسالة جديدة وتحديث ملخصات الدردشة لكلا الطرفين (باستخدام WriteBatch).
  Future<void> sendMessage({
    required String receiverId,
    required String content,
    required String senderId,
  });

  // تصفير عداد الرسائل غير المقروءة عند فتح المحادثة.
  Future<void> markMessagesAsRead(String otherUserId);
}

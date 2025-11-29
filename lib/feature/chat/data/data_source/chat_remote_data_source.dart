/// data_sources/chat_remote_data_source.dart
library;

import 'dart:async';

import 'package:blood_bank/feature/chat/data/models/chat_summary_model.dart';
import 'package:blood_bank/feature/chat/data/models/message_model.dart';
import 'package:blood_bank/feature/chat/data/models/user_model.dart';

/// واجهة المصدر عن بعد (Remote Data Source)
/// المسؤولة عن التواصل المباشر مع Firebase Firestore.
abstract class ChatRemoteDataSource {
  // ==========================================================
  // 1. وظائف القراءة (Streams)
  // ==========================================================

  /// يبث قائمة بجميع مستندات المستخدمين (UserModel).
  Stream<List<UserModel>> streamAllUsers();

  /// يبث قائمة ملخصات المحادثات للمستخدم الحالي (ChatSummaryModel).
  /// يتم جلبها من المسار: /users/{userId}/chats/{otherUserId}
  Stream<List<ChatSummaryModel>> streamChatSummaries(String currentUserId);

  /// يبث قائمة بالرسائل الفعلية في غرفة الدردشة المحددة (MessageModel).
  /// يتم جلبها من المسار: /chats/{chatId}/messages
  Stream<List<MessageModel>> streamMessages(String chatId);

  // ==========================================================
  // 2. وظائف القراءة (Futures)
  // ==========================================================

  /// يجلب بيانات مستخدم واحد بشكل فوري (Future).
  Future<UserModel> getUser(String userId);

  // ==========================================================
  // 3. وظائف الكتابة والتحديث (Futures)
  // ==========================================================

  /// إرسال رسالة جديدة. تتضمن منطق WriteBatch داخلياً في التنفيذ.
  Future<void> sendMessage({
    required String receiverId,
    required String content,
    required String senderId,
    required String chatId,
  });

  /// تصفير عداد الرسائل غير المقروءة للطرف الآخر.
  Future<void> markMessagesAsRead({
    required String currentUserId,
    required String otherUserId,
  });
}

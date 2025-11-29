import 'package:blood_bank/feature/chat/domain/entities/chat_user_entity.dart';

class ChatEntity {
  // بيانات الطرف الآخر في المحادثة
  final ChatUserEntity otherUser;

  // مُعرّف المحادثة المشترك (للوصول إلى مجموعة الرسائل chats/{chatId})
  final String? chatId;

  // محتوى آخر رسالة (مُستخلص من ملخص الدردشة في Firestore)
  final String lastMessageContent;

  // الطابع الزمني لآخر رسالة (قد يكون null إذا لم تبدأ المحادثة بعد)
  final DateTime? lastMessageTimestamp;

  // عدد الرسائل غير المقروءة (المخصص للمستخدم الحالي)
  final int unreadCount;

  // حالة قراءة رسالتي الأخيرة من قبل الطرف الآخر (لعلامتي الصح)
  final bool isLastMessageReadByMe;

  // مُعرّف مُرسِل آخر رسالة (لتحديد اتجاه الرسالة في العرض)
  final String lastMessageSenderId;

  const ChatEntity({
    required this.otherUser,
    this.chatId,
    required this.lastMessageContent,
    this.lastMessageTimestamp,
    this.unreadCount = 0,
    this.isLastMessageReadByMe = false,
    required this.lastMessageSenderId,
  });
}

import 'package:blood_bank/feature/chat/domain/entities/chat_user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/chat_entity.dart';

class ChatSummaryModel extends ChatEntity {
  // نضيف حقلين إضافيين لـ ChatSummaryModel لأنه في Firestore يخزن فقط الأيدي (IDs)
  // بينما كيان Domain (ChatEntity) يحتاج إلى كيان UserEntity كامل.
  final String otherUserId;

  const ChatSummaryModel({
    // هذه الحقول تأتي من DocumentSnapshot
    required this.otherUserId,
    required super.otherUser,
    // هذه الحقول تأتي من DocumentSnapshot
    required super.lastMessageContent,
    required super.lastMessageTimestamp,
    required super.unreadCount,
    required super.isLastMessageReadByMe,
    required super.lastMessageSenderId,
  });

  /// إنشاء النموذج من لقطة (Snapshot) من Firestore
  factory ChatSummaryModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() ?? {};
    final timestamp = data['lastMessageTimestamp'] as Timestamp?;

    // ملاحظة: UserEntity هنا هو كيان وهمي مؤقت، يجب ملؤه ببيانات المستخدم الفعلية
    // في طبقة Repository عند عملية "الدمج" (Joining Data).
    final tempUserEntity = ChatUserEntity(
      uid: snapshot.id, // ID المستند في مجموعة الملخصات هو UID للطرف الآخر
      name: 'Loading',
      avatarText: '..',
    );

    return ChatSummaryModel(
      otherUserId: snapshot.id,
      otherUser: tempUserEntity, // يتم استبدال هذا لاحقاً في المستودع
      lastMessageContent: data['lastMessageContent'] ?? '',
      lastMessageTimestamp: timestamp?.toDate(),
      unreadCount: (data['unreadCount'] as num?)?.toInt() ?? 0,
      isLastMessageReadByMe: data['isLastMessageReadByMe'] ?? false,
      lastMessageSenderId: data['lastMessageSenderId'] ?? '',
    );
  }

  /// تحويل النموذج إلى خريطة (Map) لحفظها في Firestore
  Map<String, dynamic> toJson() {
    return {
      'lastMessageContent': lastMessageContent,
      'lastMessageTimestamp': lastMessageTimestamp != null
          ? Timestamp.fromDate(lastMessageTimestamp!)
          : null,
      'unreadCount': unreadCount,
      'isLastMessageReadByMe': isLastMessageReadByMe,
      'lastMessageSenderId': lastMessageSenderId,
    };
  }
}

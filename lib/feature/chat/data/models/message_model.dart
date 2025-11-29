import 'package:blood_bank/feature/chat/domain/entities/message_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.senderId,
    required super.receiverId,
    required super.content,
    required super.timestamp,
    super.isRead,
  });

  /// إنشاء النموذج من لقطة (Snapshot) من Firestore
  factory MessageModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() ?? {};
    final timestamp = data['timestamp'] as Timestamp?;

    return MessageModel(
      id: snapshot.id,
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      content: data['content'] ?? '',
      // تحويل Timestamp من Firestore إلى DateTime
      timestamp: timestamp?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
    );
  }

  /// تحويل النموذج إلى خريطة (Map) لحفظها في Firestore
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      // يجب أن يتم إرسال Timestamp كـ FieldValue.serverTimestamp() عند الكتابة
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
    };
  }
}

import 'package:blood_bank/feature/chat/domain/entities/chat_user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends ChatUserEntity {
  const UserModel({
    required super.uid,
    required super.name,
    required super.avatarText,
    super.isOnline,
  });

  /// إنشاء النموذج من لقطة (Snapshot) من Firestore
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data() ?? {};
    return UserModel(
      uid: snapshot.id,
      name: data['name'] ?? 'No Name',
      avatarText: data['avatarText'] ?? '??',
      isOnline: data['isOnline'] ?? false,
    );
  }

  /// تحويل النموذج إلى خريطة (Map) لحفظها في Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatarText': avatarText,
      'isOnline': isOnline,
      // لا نحتاج إلى حفظ uid لأنه هو مُعرّف المستند (Document ID)
    };
  }
}

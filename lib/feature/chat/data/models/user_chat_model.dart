class UserChatModel {
  final String userId;
  final String name;
  final String imageUrl;

  final String lastMessage;
  final DateTime? lastMessageTime;
  final bool lastMessageSeen;
  final String lastMessageSenderId;

  UserChatModel({
    required this.userId,
    required this.name,
    required this.imageUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageSeen,
    required this.lastMessageSenderId,
  });

  factory UserChatModel.fromData({
    required Map<String, dynamic> userData,
    required Map<String, dynamic>? chatData,
  }) {
    return UserChatModel(
      userId: userData["uid"],
      name: userData["name"] ?? "",
      imageUrl: userData["photoUrl"] ?? "",
      lastMessage: chatData?["lastMessage"] ?? "",
      lastMessageTime: chatData?["lastMessageTime"]?.toDate(),
      lastMessageSeen: chatData?["lastMessageSeen"] ?? true,
      lastMessageSenderId: chatData?["lastMessageSenderId"] ?? "",
    );
  }
}

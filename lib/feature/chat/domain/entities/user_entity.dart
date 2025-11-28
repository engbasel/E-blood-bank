class UserEntity {
  final String uid;
  final String name;
  final String avatarText;
  final bool isOnline;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.avatarText,
    this.isOnline = false,
  });
}

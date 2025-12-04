String generateChatId(String user1Id, String user2Id) {
  return user1Id.compareTo(user2Id) < 0
      ? '${user1Id}_$user2Id'
      : '${user2Id}_$user1Id';
}

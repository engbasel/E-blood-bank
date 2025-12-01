abstract class UnreadMessagesState {}

class UnreadMessagesInitial extends UnreadMessagesState {}

class UnreadMessagesLoading extends UnreadMessagesState {}

class UnreadMessagesLoaded extends UnreadMessagesState {
  final int count;
  UnreadMessagesLoaded(this.count);
}

class UnreadMessagesError extends UnreadMessagesState {
  final String message;
  UnreadMessagesError(this.message);
}

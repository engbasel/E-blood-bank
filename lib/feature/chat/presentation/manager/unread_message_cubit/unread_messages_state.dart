abstract class UnreadMessagesState {}

class UnreadMessagesInitial extends UnreadMessagesState {}

class UnreadMessagesLoading extends UnreadMessagesState {}

class UnreadMessagesLoaded extends UnreadMessagesState {
  final Map<String, int> counts; // counts per user
  UnreadMessagesLoaded(this.counts);
}

class UnreadMessagesError extends UnreadMessagesState {
  final String message;
  UnreadMessagesError(this.message);
}

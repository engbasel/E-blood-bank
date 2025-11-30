part of 'chat_messages_cubit.dart';

abstract class ChatMessagesState {}

class ChatMessagesInitial extends ChatMessagesState {}

class ChatMessagesLoading extends ChatMessagesState {}

class ChatMessagesLoaded extends ChatMessagesState {
  final List<MessageModel> messages;
  ChatMessagesLoaded({required this.messages});
}

class ChatMessagesError extends ChatMessagesState {
  final String message;
  ChatMessagesError({required this.message});
}

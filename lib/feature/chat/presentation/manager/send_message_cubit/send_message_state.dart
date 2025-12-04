part of 'send_message_cubit.dart';

abstract class SendMessageState {}

class SendMessageInitial extends SendMessageState {}

class SendMessageLoading extends SendMessageState {}

class SendMessageSuccess extends SendMessageState {}

class SendMessageError extends SendMessageState {
  final String message;
  SendMessageError({required this.message});
}

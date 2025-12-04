import 'package:equatable/equatable.dart';
import 'package:blood_bank/feature/chat/data/models/user_chat_model.dart';

abstract class ChatUsersState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChatUsersInitial extends ChatUsersState {}

class ChatUsersLoading extends ChatUsersState {}

class ChatUsersLoaded extends ChatUsersState {
  final List<UserChatModel> users;

  ChatUsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class ChatUsersError extends ChatUsersState {
  final String message;

  ChatUsersError(this.message);

  @override
  List<Object> get props => [message];
}

import 'package:blood_bank/feature/auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;

  const Authenticated(this.user);

  @override
  List<Object> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class AuthActionInProgress extends AuthState {}

class AuthActionSuccess extends AuthState {
  final String? message;

  const AuthActionSuccess([this.message]);

  @override
  List<Object?> get props => [message];
}

class AuthActionFailure extends AuthState {
  final String message;

  const AuthActionFailure(this.message);

  @override
  List<Object> get props => [message];
}

class EmailNotVerified extends AuthState {
  final UserEntity user;

  const EmailNotVerified(this.user);

  @override
  List<Object> get props => [user];
}

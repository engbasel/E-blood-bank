import 'package:blood_bank/feature/auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class AuthStatusChanged extends AuthEvent {
  final UserEntity? user;
  const AuthStatusChanged(this.user);
}


class SignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmailEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignUpWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const SignUpWithEmailEvent({required this.email, required this.password,required this.name});

  @override
  List<Object> get props => [email, password];
}

class SignInWithGoogleEvent extends AuthEvent {}

class SignInWithFacebookEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}

class ResetPasswordEvent extends AuthEvent {
  final String email;

  const ResetPasswordEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class VerifyEmailEvent extends AuthEvent {}

class DeleteAccountEvent extends AuthEvent {}

class UpdateUserEvent extends AuthEvent {
  final String? name;
  final String? photoURL;
  final String? bloodType;

  const UpdateUserEvent({
    this.name,
    this.photoURL,
    this.bloodType,
  });

  @override
  List<Object?> get props => [name, photoURL, bloodType];
}

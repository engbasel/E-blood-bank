import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {
  final String message;

  ServerFailure([this.message = 'An error occurred']);

  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure {
  final String message;

  CacheFailure([this.message = 'Cache error occurred']);

  @override
  List<Object> get props => [message];
}

class AuthFailure extends Failure {
  final String message;

  AuthFailure([this.message = 'Authentication failed']);

  @override
  List<Object> get props => [message];
}

class NetworkFailure extends Failure {
  final String message;

  NetworkFailure([this.message = 'Network error occurred']);

  @override
  List<Object> get props => [message];
}

class ValidationFailure extends Failure {
  final String message;

  ValidationFailure([this.message = 'Validation failed']);

  @override
  List<Object> get props => [message];
}

class UnexpectedFailure extends Failure {
  final String message;

  UnexpectedFailure([this.message = 'Unexpected error occurred']);

  @override
  List<Object> get props => [message];
}

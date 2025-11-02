import 'package:blood_bank/core/error/failures.dart';
import 'package:blood_bank/feature/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';

class GetAuthStateUseCase {
  final AuthRepository repository;

  GetAuthStateUseCase(this.repository);

  Stream<UserEntity?> call() {
    return repository.authStateChanges;
  }
}

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() {
    return repository.getCurrentUser();
  }
}

class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.signOut();
  }
}

class SignInWithGoogleUseCase {
  final AuthRepository repository;

  SignInWithGoogleUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() {
    return repository.signInWithGoogle();
  }
}

class SignInWithFacebookUseCase {
  final AuthRepository repository;

  SignInWithFacebookUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() {
    return repository.signInWithFacebook();
  }
}

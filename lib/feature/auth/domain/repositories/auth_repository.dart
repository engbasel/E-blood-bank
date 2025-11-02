import 'package:blood_bank/core/error/failures.dart';
import 'package:blood_bank/feature/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, UserEntity>> signInWithGoogle();
  Future<Either<Failure, UserEntity>> signInWithFacebook();
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
      String email, String password);
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword(
      String email, String password,String name);
  Future<Either<Failure, void>> resetPassword(String email);
  Future<Either<Failure, void>> verifyEmail();
  Future<Either<Failure, void>> deleteAccount();
  Future<Either<Failure, void>> updateUserProfile(UserEntity user);
}

import 'dart:async';
import 'package:blood_bank/core/error/failures.dart';
import 'package:blood_bank/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blood_bank/feature/auth/data/models/user_model.dart';
import 'package:blood_bank/feature/auth/domain/entities/user_entity.dart';
import 'package:blood_bank/feature/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Stream<UserEntity?> get authStateChanges {
    return _remoteDataSource.authStateChanges.asyncMap((user) async {
      if (user == null) return null;

      await _remoteDataSource.reloadUser();
      final refreshedUser = await _remoteDataSource.getCurrentUser();
      if (refreshedUser == null) return null;

      try {
        final firestoreUser = await _remoteDataSource.getUserData(refreshedUser.uid);
        return firestoreUser.copyWith(
          emailVerified: refreshedUser.emailVerified,
          photoUrl: refreshedUser.photoURL,
        );
      } catch (_) {
        return UserModel.fromFirebaseUser(refreshedUser);
      }
    });
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      await _remoteDataSource.reloadUser();
      final user = await _remoteDataSource.getCurrentUser();
      if (user == null) return Left(AuthFailure('No user logged in'));

      final firestoreUser = await _remoteDataSource.getUserData(user.uid);
      final merged = firestoreUser.copyWith(
        emailVerified: user.emailVerified,
        photoUrl: user.photoURL,
      );
      return Right(merged);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(String email, String password) async {
    try {
      final user = await _remoteDataSource.signInWithEmailAndPassword(email, password);
      final firestoreUser = await _remoteDataSource.getUserData(user!.uid);
      final merged = firestoreUser.copyWith(
        emailVerified: user.emailVerified,
        photoUrl: user.photoURL,
      );
      await _remoteDataSource.saveUserData(merged);
      return Right(merged);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword(String email, String password, String name) async {
    try {
      final user = await _remoteDataSource.signUpWithEmailAndPassword(email, password, name);
      final userEntity = UserModel.fromFirebaseUser(user!).copyWith(name: name);
      await _remoteDataSource.saveUserData(userEntity);
      return Right(userEntity);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final user = await _remoteDataSource.signInWithGoogle();
      final firestoreUser = await _remoteDataSource.getUserData(user!.uid);
      final merged = firestoreUser.copyWith(
        emailVerified: user.emailVerified,
        photoUrl: user.photoURL,
      );
      await _remoteDataSource.saveUserData(merged);
      return Right(merged);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithFacebook() async {
    try {
      final user = await _remoteDataSource.signInWithFacebook();
      final firestoreUser = await _remoteDataSource.getUserData(user!.uid);
      final merged = firestoreUser.copyWith(
        emailVerified: user.emailVerified,
        photoUrl: user.photoURL,
      );
      await _remoteDataSource.saveUserData(merged);
      return Right(merged);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await _remoteDataSource.resetPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail() async {
    try {
      await _remoteDataSource.verifyEmail();
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await _remoteDataSource.deleteAccount();
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile(UserEntity user) async {
    try {
      final currentUser = await _remoteDataSource.getCurrentUser();
      if (currentUser == null) return Left(AuthFailure('No user logged in'));

      if (user.name != null) {
        await currentUser.updateDisplayName(user.name!);
      }
      if (user.photoUrl != null) {
        await currentUser.updatePhotoURL(user.photoUrl!);
      }

      await _remoteDataSource.addUserData(user);
      await _remoteDataSource.saveUserData(user);

      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }


  // UserEntity _mapFirebaseUserToEntity(User user) {
  //   return UserEntity(
  //     uId: user.uid,
  //     name: user.displayName,
  //     email: user.email,
  //     photoUrl: user.photoURL,
  //     emailVerified: user.emailVerified,
  //     userState:   'allowed',
  //   );
  // }
}


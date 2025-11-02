import 'package:blood_bank/core/error/failures.dart';
import 'package:blood_bank/feature/auth/domain/entities/user_entity.dart';
import 'package:blood_bank/feature/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class SignInWithEmail {
  final AuthRepository repository;

  SignInWithEmail(this.repository);

  Future<Either<Failure, UserEntity>> call(
      String email, String password) async {
    return await repository.signInWithEmailAndPassword(email, password);
  }
}

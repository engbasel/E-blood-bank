import 'package:blood_bank/core/error/failures.dart';
import 'package:blood_bank/feature/auth/domain/entities/user_entity.dart';
import 'package:blood_bank/feature/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class SignUpWithEmail {
  final AuthRepository repository;

  SignUpWithEmail(this.repository);

  Future<Either<Failure, UserEntity>> call(
      String email, String password,String name) async {
    return await repository.signUpWithEmailAndPassword(email, password,name);
  }
}

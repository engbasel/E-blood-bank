import 'package:blood_bank/core/error/failures.dart';
import 'package:blood_bank/feature/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class VerifyEmail {
  final AuthRepository repository;

  VerifyEmail(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.verifyEmail();
  }
}

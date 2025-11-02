import 'package:blood_bank/core/error/failures.dart';
import 'package:blood_bank/feature/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class ResetPassword {
  final AuthRepository repository;

  ResetPassword(this.repository);

  Future<Either<Failure, void>> call(String email) async {
    return await repository.resetPassword(email);
  }
}

import 'package:blood_bank/core/error/failures.dart';
import 'package:blood_bank/feature/auth/domain/entities/user_entity.dart';
import 'package:blood_bank/feature/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateUserProfile {
  final AuthRepository repository;

  UpdateUserProfile(this.repository);

  Future<Either<Failure, void>> call(UserEntity user) async {
    return await repository.updateUserProfile(user);
  }
}

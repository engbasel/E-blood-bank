import 'package:blood_bank/core/errors/failures.dart';
import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';
import 'package:blood_bank/feature/home/domain/repos/doner_repo.dart';
import 'package:dartz/dartz.dart';

class AddDonerRequestUseCase {
  final DonerRepo repo;

  AddDonerRequestUseCase(this.repo);

  Future<Either<Failures, void>> call(DonerRequestEntity entity) async {
    return await repo.addRequest(entity);
  }
}

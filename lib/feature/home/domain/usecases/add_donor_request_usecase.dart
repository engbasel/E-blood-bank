import 'package:blood_bank/core/errors/failures.dart';
import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';
import 'package:blood_bank/feature/home/domain/repos/donor_repo.dart';
import 'package:dartz/dartz.dart';

class AddDonorRequestUseCase {
  final DonorRepo repo;

  AddDonorRequestUseCase(this.repo);

  Future<Either<Failures, void>> call(DonorRequestEntity entity) async {
    return await repo.addRequest(entity);
  }
}

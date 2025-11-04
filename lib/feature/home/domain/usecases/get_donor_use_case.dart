import 'package:blood_bank/core/errors/failures.dart';
import 'package:blood_bank/feature/home/domain/repos/donor_repo.dart';
import 'package:dartz/dartz.dart';

class GetDonorByIdUseCase {
  final DonorRepo repo;

  GetDonorByIdUseCase(this.repo);

  Future<Either<Failures, Map<dynamic, dynamic>>> call(String userId) async {
    return await repo.getDonorById(userId);
  }
}

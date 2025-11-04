import 'package:blood_bank/core/errors/failures.dart';
import 'package:blood_bank/feature/home/data/datasources/doner_remote_data_source.dart';
import 'package:blood_bank/feature/home/data/model/doner_model.dart';
import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';
import 'package:blood_bank/feature/home/domain/repos/donor_repo.dart';
import 'package:dartz/dartz.dart';

class DonorRepoImpl implements DonorRepo {
  final DonorRemoteDataSource _donorRemoteDataSource;

  DonorRepoImpl({required DonorRemoteDataSource donorRemoteDataSource})
      : _donorRemoteDataSource = donorRemoteDataSource;
  @override
  Future<Either<Failures, void>> addRequest(
      DonorRequestEntity addRequestInputEntity) async {
    try {
      await _donorRemoteDataSource
          .addDonorRequest(DonerModel.fromEntity(addRequestInputEntity));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to add Request'));
    }
  }
  @override
  Future<Either<Failures, Map<dynamic, dynamic>>> getDonorById(
      String userId) async {
    try {
      final data = await _donorRemoteDataSource.getFullDonorData(userId);
      if (data != null) {
        return Right(data);
      } else {
        return Left(ServerFailure('Donor not found'));
      }
    } catch (e) {
      return Left(ServerFailure('Failed to fetch donor data'));
    }
  }
}

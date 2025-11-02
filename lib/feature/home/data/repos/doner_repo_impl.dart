import 'package:blood_bank/core/errors/failures.dart';
import 'package:blood_bank/feature/home/data/datasources/doner_remote_data_source.dart';
import 'package:blood_bank/feature/home/data/model/doner_model.dart';
import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';
import 'package:blood_bank/feature/home/domain/repos/doner_repo.dart';
import 'package:dartz/dartz.dart';

class DonerRepoImpl implements DonerRepo {
  final DonerRemoteDataSource _donerRemoteDataSource;

  DonerRepoImpl({required DonerRemoteDataSource donerRemoteDataSource})
      : _donerRemoteDataSource = donerRemoteDataSource;
  @override
  Future<Either<Failures, void>> addRequest(
      DonerRequestEntity addRequestInputEntity) async {
    try {
      await _donerRemoteDataSource
          .addDonerRequest(DonerModel.fromEntity(addRequestInputEntity));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to add Request'));
    }
  }
}

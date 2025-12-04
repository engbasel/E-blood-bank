import 'dart:developer';
import 'package:blood_bank/core/errors/failures.dart';
import 'package:blood_bank/core/mapper/need_mapper.dart';
import 'package:blood_bank/feature/home/data/datasources/needer_remote_data_source.dart';
import 'package:blood_bank/feature/home/domain/entities/needer_request_entity.dart';
import 'package:blood_bank/feature/home/domain/repos/needer_repo.dart';
import 'package:dartz/dartz.dart';

class NeederRepoImpl implements NeederRepo {
  final NeederRemoteDataSource remoteDataSource;

  NeederRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failures, void>> addNeederRequest(
      NeederRequestEntity addNeederInputEntity) async {
    try {
      final hasActive =
      await remoteDataSource.hasActiveRequest(addNeederInputEntity.uId);
      if (hasActive) {
        return Left(ServerFailure('activeRequest'));
      }

      final model = NeederMapper.toModel(addNeederInputEntity);
      await remoteDataSource.addNeederRequest(model);

      return const Right(null);
    } catch (e) {
      log('NeederRepoImpl.addNeederRequest error: $e');
      return Left(
        ServerFailure('Failed to add Request'),
      );
    }
  }

  @override
  Stream<List<NeederRequestEntity>> getAcceptedRequests() {
      return remoteDataSource.getAcceptedRequests()
          .map((models) => models.map(NeederMapper.toEntity).toList());

  }


}


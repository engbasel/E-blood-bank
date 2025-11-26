import 'package:blood_bank/core/errors/failures.dart';
import 'package:blood_bank/feature/home/domain/entities/needer_request_entity.dart';
import 'package:blood_bank/feature/home/domain/repos/needer_repo.dart';
import 'package:dartz/dartz.dart';

class GetAcceptedNeederRequestsUseCase {
  final NeederRepo repo;

  GetAcceptedNeederRequestsUseCase(this.repo);

  Future<Either<Failures, List<NeederRequestEntity>>> call() async {
    return await repo.getAcceptedRequests();
  }
}

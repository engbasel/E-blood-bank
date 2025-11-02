import 'package:blood_bank/core/errors/failures.dart';
import 'package:blood_bank/feature/home/domain/entities/needer_request_entity.dart';
import 'package:blood_bank/feature/home/domain/repos/needer_repo.dart';
import 'package:dartz/dartz.dart';

class AddNeederRequestUseCase {
  final NeederRepo repo;

  AddNeederRequestUseCase(this.repo);

  Future<Either<Failures, void>> call(NeederRequestEntity entity) async {
    return await repo.addNeederRequest(entity);
  }
}

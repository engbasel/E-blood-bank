import 'package:blood_bank/feature/home/domain/entities/needer_request_entity.dart';
import 'package:blood_bank/feature/home/domain/repos/needer_repo.dart';

class GetAcceptedNeederRequestsUseCase {
  final NeederRepo repo;

  GetAcceptedNeederRequestsUseCase(this.repo);

  Stream<List<NeederRequestEntity>> call()  {
    return  repo.getAcceptedRequests();
  }
}

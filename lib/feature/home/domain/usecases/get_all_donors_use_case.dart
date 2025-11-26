import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';
import 'package:blood_bank/feature/home/domain/repos/donor_repo.dart';

class GetAllDonorRequestsUseCase {
  final DonorRepo repo;
  GetAllDonorRequestsUseCase(this.repo);

  Stream<List<DonorRequestEntity>> call() {
    return repo.getAllDonorRequests();
  }
}
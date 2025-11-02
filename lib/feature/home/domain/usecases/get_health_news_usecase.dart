import 'package:blood_bank/feature/home/domain/repos/health_repo.dart';
import 'package:blood_bank/feature/home/data/model/health_model.dart';

class GetHealthNewsUseCase {
  final HealthRepo _healthRepo;

  GetHealthNewsUseCase(this._healthRepo);

  Future<List<HealthModel>> call() async {
    return await _healthRepo.getHealthNews();
  }
}

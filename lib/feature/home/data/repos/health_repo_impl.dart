import 'package:blood_bank/core/errors/failures.dart';
import 'package:blood_bank/core/services/health_request.dart';
import 'package:blood_bank/feature/home/domain/repos/health_repo.dart';
import 'package:blood_bank/feature/home/data/model/health_model.dart';
// dartz not required here

class HealthRepoImpl implements HealthRepo {
  final HealthRequest _healthRequest;

  HealthRepoImpl({required HealthRequest healthRequest})
      : _healthRequest = healthRequest;

  @override
  Future<List<HealthModel>> getHealthNews() async {
    try {
      final articles = await _healthRequest.news(category: 'health');
      return articles;
    } catch (e) {
      throw ServerFailure('Failed to fetch health news');
    }
  }
}

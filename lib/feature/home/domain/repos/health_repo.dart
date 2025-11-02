import 'package:blood_bank/feature/home/data/model/health_model.dart';

abstract class HealthRepo {
  Future<List<HealthModel>> getHealthNews();
}

import 'package:blood_bank/core/services/data_service.dart';
import 'package:blood_bank/feature/home/data/model/doner_model.dart';

abstract class DonerRemoteDataSource {
  Future<void> addDonerRequest(DonerModel model);
  Future<bool> hasActiveRequest(String userId);
  Future<Map<String, dynamic>?> getUserById(String userId);
}

class DonerRemoteDataSourceImpl implements DonerRemoteDataSource {
  final DatabaseService databaseService;

  DonerRemoteDataSourceImpl(this.databaseService);

  @override
  Future<void> addDonerRequest(DonerModel model) async {
    await databaseService.addData(
      path: 'donerRequest',
      data: model.toJson(),
      docuementId: null,
    );
  }

  @override
  Future<bool> hasActiveRequest(String userId) async {
    try {
      final data = await databaseService.getData(path: 'donerRequest');
      if (data is List) {
        return data.any((e) => e['uId'] == userId);
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      final data =
          await databaseService.getData(path: 'users', docuementId: userId);
      if (data is Map<String, dynamic>) return data;
      return null;
    } catch (_) {
      return null;
    }
  }
}

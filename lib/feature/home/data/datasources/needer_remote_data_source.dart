import 'package:blood_bank/feature/home/data/model/needer_model.dart';
import 'package:blood_bank/core/services/data_service.dart';

abstract class NeederRemoteDataSource {
  Future<void> addNeederRequest(NeederModel model);
  Future<bool> hasActiveRequest(String userId);
  Future<Map<String, dynamic>?> getUserById(String userId);

  Future<List<NeederModel>> getAcceptedRequests();
}

class NeederRemoteDataSourceImpl implements NeederRemoteDataSource {
  final DatabaseService databaseService;

  NeederRemoteDataSourceImpl(this.databaseService);

  @override
  Future<void> addNeederRequest(NeederModel model) async {
    await databaseService.addData(
      path: 'neederRequest',
      data: model.toJson(),
      docuementId: null,
    );
  }

  @override
  Future<bool> hasActiveRequest(String userId) async {
    try {
      final data = await databaseService.getData(path: 'neederRequest');
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

  @override
  Future<List<NeederModel>> getAcceptedRequests() async {
    try {
      final data = await databaseService.getData(path: 'neederRequest');
      if (data is List) {
        final accepted = data.where((e) => e['status'] == 'accepted').toList();
        return accepted.map((e) => NeederModel.fromEntity(e)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}


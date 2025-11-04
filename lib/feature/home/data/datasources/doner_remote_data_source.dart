import 'package:blood_bank/core/services/data_service.dart';
import 'package:blood_bank/feature/home/data/model/doner_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DonorRemoteDataSource {
  Future<void> addDonorRequest(DonerModel model);
  Future<bool> hasActiveRequest(String userId);
  Future<Map?> getFullDonorData(String userId);
}

class DonorRemoteDataSourceImpl implements DonorRemoteDataSource {
  final DatabaseService databaseService;

  DonorRemoteDataSourceImpl(this.databaseService);

  @override
  Future<void> addDonorRequest(DonerModel model) async {
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
  Future<Map?> getFullDonorData(String userId) async {
    try {
      final userData = await databaseService.getData(path: 'users', docuementId: userId);

      final requestSnapshot = await FirebaseFirestore.instance
          .collection('donerRequest')
          .where('uId', isEqualTo: userId)
          .get();

      final requestData = requestSnapshot.docs.isNotEmpty ? requestSnapshot.docs.first.data() : {};

      if (userData is Map<String, dynamic>) {
        return {...userData, ...requestData};
      } else {
        return requestData.isNotEmpty ? requestData : null;
      }
    } catch (_) {
      return null;
    }
  }

}

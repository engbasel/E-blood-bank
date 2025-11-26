import 'package:blood_bank/core/services/data_service.dart';
import 'package:blood_bank/feature/home/data/model/doner_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DonorRemoteDataSource {
  Future<void> addDonorRequest(DonorModel model);
  Future<bool> hasActiveRequest(String userId);

  Stream<List<DonorModel>> getAllDonorRequests();
}

class DonorRemoteDataSourceImpl implements DonorRemoteDataSource {
  final DatabaseService databaseService;

  DonorRemoteDataSourceImpl(this.databaseService);

  @override
  Future<void> addDonorRequest(DonorModel model) async {
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
  Stream<List<DonorModel>> getAllDonorRequests() {
    return FirebaseFirestore.instance
        .collection('donerRequest')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => DonorModel.fromJson(doc.data())).toList());
  }

}

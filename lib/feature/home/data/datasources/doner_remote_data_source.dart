import 'dart:async';
import 'dart:developer';
import 'package:blood_bank/core/services/data_service.dart';
import 'package:blood_bank/feature/home/data/model/doner_model.dart';
import 'package:blood_bank/feature/notification/notification_service.dart';
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
    try {
      await databaseService.addData(
        path: 'donerRequest',
        data: model.toJson(),
        docuementId: null,
      );

      // unawaited(_sendNotification(model));
    } catch (e, st) {
      log("Error in addDonorRequest: $e\n$st");
      rethrow;
    }
  }

  Future<void> _sendNotification(DonorModel model) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(model.uId).get();
    final userEmail = userDoc.data()?['email'] ?? '';

    await NotificationService.instance.sendNotification(
      title: "New Blood Request",
      body: "${model.name} Wants to donate blood!",
      data: {
        "user_name": model.name,
        "user_email": userEmail,
        "photoUrl": model.photoUrl,
        "request_id": model.uId,
        "type": "new_request",
      },
      excludeUserId: model.uId,
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

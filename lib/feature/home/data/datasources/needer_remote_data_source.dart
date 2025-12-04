import 'dart:async';
import 'dart:developer';
import 'package:blood_bank/feature/home/data/model/needer_model.dart';
import 'package:blood_bank/core/services/data_service.dart';
import 'package:blood_bank/feature/notification/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class NeederRemoteDataSource {
  Future<void> addNeederRequest(NeederModel model);

  Future<bool> hasActiveRequest(String userId);

  Future<Map<String, dynamic>?> getUserById(String userId);

  Stream<List<NeederModel>> getAcceptedRequests();
}

class NeederRemoteDataSourceImpl implements NeederRemoteDataSource {
  final DatabaseService databaseService;

  NeederRemoteDataSourceImpl(this.databaseService);

  @override
  Future<void> addNeederRequest(NeederModel model) async {
    try {
      await databaseService.addData(
        path: 'neederRequest',
        data: model.toJson(),
        docuementId: null,
      );
    } catch (e, st) {
      log("Error in addNeederRequest: $e\n$st");
      rethrow;
    }
  }

  Future<void> sendApprovalNotifications(NeederModel model) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(model.uId)
        .get();
    final userEmail = userDoc.data()?['email'] ?? '';
    final userPhoto = userDoc.data()?['photoUrl'] ?? '';

    await NotificationService.instance.sendNotification(
      title: "Approved Blood Request",
      body: "${model.patientName} needs ${model.bloodType}.",
      data: {
        "user_name": model.patientName,
        "user_email": userEmail,
        "photoUrl": "",
        "request_id": model.uId,
        "type": "approved_request_broadcast",
      },
      excludeUserId: model.uId,
    );

    final userTokenDoc = await FirebaseFirestore.instance
        .collection('userTokens')
        .doc(model.uId)
        .get();

    final token = userTokenDoc.data()?['token'];
    if (token != null) {
      await NotificationService.instance.sendNotificationToUser(
        token: token,
        title: "Request Approved",
        body: "Your blood request has been approved by admin.",
        data: {
          "request_id": model.uId,
          "photoUrl": userPhoto,
          "type": "request_approved",
        },
      );
    }
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
  @override
  Stream<List<NeederModel>> getAcceptedRequests() {
    return FirebaseFirestore.instance
        .collection('neederRequest')
        .snapshots()
        .map((snapshot) {
      final acceptedModels = snapshot.docs
          .map((doc) => NeederModel.fromJson(doc.data()))
          .where((model) => model.status.toLowerCase() == 'accepted')
          .toList();


      for (final model in acceptedModels) {
        sendApprovalNotifications(model);
      }

      return acceptedModels;
    });
  }

}

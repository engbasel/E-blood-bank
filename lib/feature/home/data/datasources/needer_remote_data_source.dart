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
    unawaited(_sendNotification(model));
  } catch (e, st) {
  log("Error in addNeederRequest: $e\n$st");
  rethrow;
}
  }

  Future<void> _sendNotification(NeederModel model) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(model.uId).get();
    final userEmail = userDoc.data()?['email'] ?? '';

    await NotificationService.instance.sendNotificationToAllUsers(
      title: "New Blood Request",
      body: "${model.patientName} Needs blood of type ${model.bloodType}",
      data: {
        "user_name": model.patientName,
        "user_email": userEmail,
        "photoUrl": "",
        "request_id": model.uId,
        "type": "new_request",
      },
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
  Stream<List<NeederModel>> getAcceptedRequests()  {
    return FirebaseFirestore.instance
        .collection('neederRequest')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => NeederModel.fromJson(doc.data()))
        .where((model) => model.status.toLowerCase() == 'accepted')
        .toList());
  }
}

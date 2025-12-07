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

  Future<void> sendApprovalNotifications(NeederModel model, {required String requestDocId}) ;

  Future<void> rejectedNotifications(NeederModel model, {required String requestDocId}) ;
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

  @override
  Future<void> sendApprovalNotifications(NeederModel model, {required String requestDocId}) async {

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(model.uId)
        .get();
    final userEmail = userDoc.data()?['email'] ?? '';
    final userPhoto = userDoc.data()?['photoUrl'] ?? '';

    final userTokenDoc = await FirebaseFirestore.instance
        .collection('userTokens')
        .doc(model.uId)
        .get();

    final token = userTokenDoc.data()?['token'];
    if (token != null) {
      await NotificationService.instance.sendNotificationToUser(
        token: token,
        title: "Request approved",
        body: "Your blood request has been approved by admin.",
        data: {
          "request_id": requestDocId,
          "photoUrl": userPhoto,
          "type": "request_approved",
        },
      );
    }


    await NotificationService.instance.sendNotification(
      title: "blood request",
      body: "${model.patientName} needs ${model.bloodType}.",
      data: {
        "user_name": model.patientName,
        "user_email": userEmail,
        "photoUrl": userPhoto,
        "request_id": requestDocId,
        "type": "approved_request_broadcast",
      },
      excludeUserId: model.uId,
    );



  }

  @override
  Future<void> rejectedNotifications(NeederModel model, {required String requestDocId}) async {

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(model.uId)
        .get();
    final userPhoto = userDoc.data()?['photoUrl'] ?? '';


    final userTokenDoc = await FirebaseFirestore.instance
        .collection('userTokens')
        .doc(model.uId)
        .get();

    final token = userTokenDoc.data()?['token'];
    if (token != null) {
      await NotificationService.instance.sendNotificationToUser(
        token: token,
        title: "Request rejected",
        body: "Your blood request has been rejected by admin.",
        data: {
          "request_id": requestDocId,
          "photoUrl": userPhoto,
          "type": "request_rejected",
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
      final data = await databaseService.getData(path: 'users', docuementId: userId);
      if (data is Map<String, dynamic>) return data;
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<List<NeederModel>> getAcceptedRequests() {
    return FirebaseFirestore.instance
        .collection('neederRequest')
        .snapshots()
        .map((snapshot) {
      for (final doc in snapshot.docs) {
        final data = doc.data();

        final status = (data['status'] ?? '').toString().toLowerCase();
        final notified = (data['notified'] ?? false) == true;

        if (status == 'approved' && !notified) {
          final model = NeederModel.fromJson(data);

          Future.microtask(() async {
            try {
              await sendApprovalNotifications(model, requestDocId: doc.id);
            } catch (e, st) {
              log("Error sending notifications: $e\n$st");
            } finally {
              try {
                await FirebaseFirestore.instance
                    .collection('neederRequest')
                    .doc(doc.id)
                    .update({'notified': true});
              } catch (e, st) {
                log("Error flagging notified: $e\n$st");
              }
            }
          });
        }

        if (status == 'rejected' && !notified) {
          final model = NeederModel.fromJson(data);

          Future.microtask(() async {
            try {
              await rejectedNotifications(model, requestDocId: doc.id);
            } catch (e, st) {
              log("Error sending notifications: $e\n$st");
            } finally {
              try {
                await FirebaseFirestore.instance
                    .collection('neederRequest')
                    .doc(doc.id)
                    .update({'notified': true});
              } catch (e, st) {
                log("Error flagging notified: $e\n$st");
              }
            }
          });
        }
      }

      return snapshot.docs
          .map((doc) => NeederModel.fromJson(doc.data()))
          .where((model) => model.status.toLowerCase() == 'approved')
          .toList();
    });
  }
}


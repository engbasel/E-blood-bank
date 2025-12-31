import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:blood_bank/feature/notification/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blood_bank/feature/chat/data/models/agreement_model.dart';
import 'package:flutter/material.dart';
import 'agreement_repo.dart';

class AgreementRepoImpl implements AgreementRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> createAgreement(
      AgreementModel agreement, String donorName, BuildContext context) async {
    final docRef = _firestore.collection('agreements').doc();

    final finalAgreement = agreement.copyWith(id: docRef.id);

    await docRef.set(finalAgreement.toMap());

    await _notifyPartner(
      targetUserId: finalAgreement.donorId,
      title: "New Donation Agreement".tr(context),
      body: "You have a new donation agreement with $donorName.",
      data: {
        "type": "agreement",
        "agreementId": finalAgreement.id,
        "neederId": finalAgreement.neederId,
      },
    );
  }

  @override
  Future<void> updateDonorDecision(String agreementId, String decision) async {
    await _firestore.collection('agreements').doc(agreementId).update({
      'donorDecision': decision,
    });

    final agreement = await getAgreementById(agreementId);
    if (agreement != null) {
      await _notifyPartner(
        targetUserId: agreement.neederId,
        title: "تحديث من المتبرع",
        body: "قام المتبرع بتحديث قراره إلى: $decision",
        data: {"type": "agreement", "id": agreementId},
      );
    }
  }

  @override
  Future<void> updateRecipientDecision(
      String agreementId, String decision) async {
    await _firestore.collection('agreements').doc(agreementId).update({
      'recipientDecision': decision,
    });

    final agreement = await getAgreementById(agreementId);
    if (agreement != null) {
      await _notifyPartner(
        targetUserId: agreement.donorId,
        title: "تحديث من المستلم",
        body: "قام المستلم بتحديث قراره إلى: $decision",
        data: {"type": "agreement", "id": agreementId},
      );
    }
  }

  @override
  Future<void> completeAgreement(String agreementId) async {
    await _firestore.collection('agreements').doc(agreementId).update({
      'status': 'completed',
    });
  }

  @override
  Future<void> cancelAgreement(String agreementId) async {
    final agreement = await getAgreementById(agreementId);
    await _firestore.collection('agreements').doc(agreementId).delete();

    if (agreement != null) {
      await _notifyPartner(
        targetUserId: agreement.neederId,
        title: "إلغاء الاتفاقية",
        body: "تم إلغاء اتفاقية التبرع.",
        data: {"type": "agreement_cancelled"},
      );
    }
  }

  @override
  Future<AgreementModel?> getAgreementById(String id) async {
    final doc = await _firestore.collection('agreements').doc(id).get();
    if (doc.exists && doc.data() != null) {
      // تمرير البيانات والمعرف كمعاملين منفصلين كما يتوقع الموديل
      return AgreementModel.fromMap(
        doc.data()!,
      );
    }
    return null;
  }

  @override
  Stream<List<AgreementModel>> watchUserAgreements(String userId) {
    return _firestore
        .collection('agreements')
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AgreementModel.fromMap(
                  doc.data(),
                ))
            .toList());
  }

  Future<void> _notifyPartner({
    required String targetUserId,
    required String title,
    required String body,
    required Map<String, String> data,
  }) async {
    try {
      final tokenDoc =
          await _firestore.collection('userTokens').doc(targetUserId).get();
      if (tokenDoc.exists) {
        final token = tokenDoc.data()?['token'];
        if (token != null) {
          await NotificationService.instance.sendNotificationToUser(
            token: token,
            title: title,
            body: body,
            data: data,
          );
        }
      }
    } catch (e) {
      // log error
    }
  }
}

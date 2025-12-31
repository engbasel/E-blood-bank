import 'package:blood_bank/feature/chat/data/models/agreement_model.dart';
import 'package:flutter/material.dart';

abstract class AgreementRepo {
  Future<void> createAgreement(
      AgreementModel agreement, String donorName, BuildContext context);

  // جلب اتفاقية معينة بواسطة المعرف
  Future<AgreementModel?> getAgreementById(String id);

  // تحديث قرار المتبرع (وافقت، رفضت، تم التبرع)
  Future<void> updateDonorDecision(String agreementId, String decision);

  // تحديث قرار المستلم (طلبت، سحبت الطلب، تم الاستلام)
  Future<void> updateRecipientDecision(String agreementId, String decision);

  // إنهاء الاتفاقية بنجاح
  Future<void> completeAgreement(String agreementId);

  // إلغاء الاتفاقية
  Future<void> cancelAgreement(String agreementId);

  // مراقبة الاتفاقيات الخاصة بالمستخدم (تحديث مباشر)
  Stream<List<AgreementModel>> watchUserAgreements(String userId);
}

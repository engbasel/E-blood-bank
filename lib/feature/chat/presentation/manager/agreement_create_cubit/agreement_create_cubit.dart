import 'dart:developer';

import 'package:blood_bank/feature/chat/data/repo/agreement_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_bank/feature/chat/data/models/agreement_model.dart';
import 'agreement_create_state.dart';

class AgreementCreateCubit extends Cubit<AgreementCreateState> {
  final AgreementRepo _agreementRepo;

  AgreementCreateCubit(this._agreementRepo) : super(AgreementCreateInitial());

  Future<void> createNewAgreement({required AgreementModel agreement}) async {
    emit(AgreementCreateLoading());

    try {
      await _agreementRepo.createAgreement(agreement);
      emit(AgreementCreateSuccess(agreement));
    } catch (e) {
      emit(AgreementCreateError("فشل في إنشاء الاتفاقية: ${e.toString()}"));
      log("Error in createNewAgreement: ${e.toString()}",
          name: "AgreementCreateCubit");
    }
  }

  void resetState() {
    emit(AgreementCreateInitial());
  }
}

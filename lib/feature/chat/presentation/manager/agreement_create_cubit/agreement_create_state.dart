import 'package:blood_bank/feature/chat/data/models/agreement_model.dart';

abstract class AgreementCreateState {}

class AgreementCreateInitial extends AgreementCreateState {}

class AgreementCreateLoading extends AgreementCreateState {}

class AgreementCreateSuccess extends AgreementCreateState {
  final AgreementModel agreement;
  AgreementCreateSuccess(this.agreement);
}

class AgreementCreateError extends AgreementCreateState {
  final String message;
  AgreementCreateError(this.message);
}

import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';

abstract class DonorRequestsState {}

class DonorRequestsInitial extends DonorRequestsState {}

class DonorRequestsLoading extends DonorRequestsState {}

class DonorRequestsSuccess extends DonorRequestsState {
  final List<DonorRequestEntity> requests;
  DonorRequestsSuccess(this.requests);
}


class DonorRequestsFailure extends DonorRequestsState {
  final String message;
  DonorRequestsFailure(this.message);
}

class DonorRequestsLoaded extends DonorRequestsState {
  final List<DonorRequestEntity> requests;
  DonorRequestsLoaded(this.requests);
}

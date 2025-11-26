import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';
//
// abstract class AddDonorRequestEvent {}
//
// class SubmitDonorRequestEvent extends AddDonorRequestEvent {
//   final DonorRequestEntity request;
//   SubmitDonorRequestEvent({required this.request});
// }
//
// class GetDonorByIdEvent extends AddDonorRequestEvent {
//   final String userId;
//   GetDonorByIdEvent({required this.userId});
// }
// class ListenToDonorRequestsEvent extends AddDonorRequestEvent {}
//
// class DonorRequestsUpdatedEvent extends AddDonorRequestEvent {
//   final List<DonorRequestEntity> requests;
//   DonorRequestsUpdatedEvent(this.requests);
// }

abstract class DonorRequestsEvent {}

class SubmitDonorRequestEvent extends DonorRequestsEvent {
  final DonorRequestEntity request;
  SubmitDonorRequestEvent({required this.request});
}

class ListenToDonorRequestsEvent extends DonorRequestsEvent {}

class DonorRequestsUpdatedEvent extends DonorRequestsEvent {
  final List<DonorRequestEntity> requests;
  DonorRequestsUpdatedEvent({required this.requests});
}

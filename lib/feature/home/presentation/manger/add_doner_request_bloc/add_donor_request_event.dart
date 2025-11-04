import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';

abstract class AddDonorRequestEvent {}

class SubmitDonorRequestEvent extends AddDonorRequestEvent {
  final DonorRequestEntity request;
  SubmitDonorRequestEvent({required this.request});
}

class GetDonorByIdEvent extends AddDonorRequestEvent {
  final String userId;
  GetDonorByIdEvent({required this.userId});
}

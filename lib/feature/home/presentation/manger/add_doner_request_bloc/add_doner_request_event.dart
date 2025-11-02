import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';

abstract class AddDonerRequestEvent {}

class SubmitDonerRequestEvent extends AddDonerRequestEvent {
  final DonerRequestEntity request;

  SubmitDonerRequestEvent(this.request);
}

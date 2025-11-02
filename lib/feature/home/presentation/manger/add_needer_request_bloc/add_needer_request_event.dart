import 'package:blood_bank/feature/home/domain/entities/needer_request_entity.dart';

abstract class AddNeederRequestEvent {}

class SubmitNeederRequestEvent extends AddNeederRequestEvent {
  final NeederRequestEntity request;

  SubmitNeederRequestEvent(this.request);
}

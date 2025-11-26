import 'package:blood_bank/feature/home/domain/entities/needer_request_entity.dart';

abstract class AddNeederRequestState {}

class AddNeederRequestInitial extends AddNeederRequestState {}

class AddNeederRequestLoading extends AddNeederRequestState {}

class AddNeederRequestSuccess extends AddNeederRequestState {}

class AddNeederRequestFailure extends AddNeederRequestState {
  final String message;
  AddNeederRequestFailure(this.message);
}

class AcceptedNeederRequestsLoading extends AddNeederRequestState {}

class AcceptedNeederRequestsLoaded extends AddNeederRequestState {
  final List<NeederRequestEntity> requests;
  AcceptedNeederRequestsLoaded(this.requests);
}

class AcceptedNeederRequestsFailure extends AddNeederRequestState {
  final String message;
  AcceptedNeederRequestsFailure(this.message);
}
abstract class AddNeederRequestState {}

class AddNeederRequestInitial extends AddNeederRequestState {}

class AddNeederRequestLoading extends AddNeederRequestState {}

class AddNeederRequestSuccess extends AddNeederRequestState {}

class AddNeederRequestFailure extends AddNeederRequestState {
  final String message;
  AddNeederRequestFailure(this.message);
}

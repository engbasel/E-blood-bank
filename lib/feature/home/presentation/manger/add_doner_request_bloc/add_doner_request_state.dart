abstract class AddDonerRequestState {}

class AddDonerRequestInitial extends AddDonerRequestState {}

class AddDonerRequestLoading extends AddDonerRequestState {}

class AddDonerRequestSuccess extends AddDonerRequestState {}

class AddDonerRequestFailure extends AddDonerRequestState {
  final String message;
  AddDonerRequestFailure(this.message);
}

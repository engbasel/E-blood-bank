abstract class AddDonorRequestState {}

class AddDonorRequestInitial extends AddDonorRequestState {}

class AddDonorRequestLoading extends AddDonorRequestState {}

class AddDonorRequestSuccess extends AddDonorRequestState {}

class AddDonorRequestFailure extends AddDonorRequestState {
  final String message;
  AddDonorRequestFailure(this.message);
}

class DonorDataLoaded extends AddDonorRequestState {
  final Map<dynamic, dynamic> donorData;
  DonorDataLoaded(this.donorData);
}

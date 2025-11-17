import 'package:blood_bank/feature/home/domain/usecases/add_donor_request_usecase.dart';
import 'package:blood_bank/feature/home/domain/usecases/get_donor_use_case.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_event.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddDonorRequestBloc extends Bloc<AddDonorRequestEvent, AddDonorRequestState> {
  final AddDonorRequestUseCase _addUseCase;
  final GetDonorByIdUseCase _getUseCase;

  AddDonorRequestBloc(this._addUseCase, this._getUseCase)
      : super(AddDonorRequestInitial()) {
    on<SubmitDonorRequestEvent>(_onSubmitRequest);
    on<GetDonorByIdEvent>(_onGetDonor);
  }

  Future<void> _onSubmitRequest(
      SubmitDonorRequestEvent event, Emitter<AddDonorRequestState> emit) async {
    emit(AddDonorRequestLoading());
    final res = await _addUseCase(event.request);
    res.fold(
          (failure) => emit(AddDonorRequestFailure(failure.message)),
          (_) => emit(AddDonorRequestSuccess()),
    );
  }

  Future<void> _onGetDonor(
      GetDonorByIdEvent event, Emitter<AddDonorRequestState> emit) async {
    emit(AddDonorRequestLoading());
    final res = await _getUseCase(event.userId);
    res.fold(
          (failure) => emit(AddDonorRequestFailure(failure.message)),
          (data) {
            emit(DonorDataLoaded(data));
          },
    );
  }
}


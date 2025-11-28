import 'dart:async';
import 'package:blood_bank/feature/home/domain/usecases/add_donor_request_usecase.dart';
import 'package:blood_bank/feature/home/domain/usecases/get_all_donors_use_case.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_event.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DonorRequestsBloc extends Bloc<DonorRequestsEvent, DonorRequestsState> {
  final GetAllDonorRequestsUseCase _getAllUseCase;
  final AddDonorRequestUseCase _addUseCase;

  DonorRequestsBloc( this._addUseCase,this._getAllUseCase,)
      : super(DonorRequestsInitial()) {
    on<ListenToDonorRequestsEvent>(_onListen);
    on<DonorRequestsUpdatedEvent>(_onUpdated);
    on<SubmitDonorRequestEvent>(_onSubmitRequest);
  }

  Future<void> _onSubmitRequest(
      SubmitDonorRequestEvent event, Emitter<DonorRequestsState> emit) async {
    emit(DonorRequestsLoading());
    final res = await _addUseCase(event.request);

    await res.fold(
          (failure) async {
        emit(DonorRequestsFailure(failure.message));
      },
          (_) async {
        final allRequests = await _getAllUseCase().first;
        emit(DonorRequestsSuccess(allRequests));
      },
    );
  }


  void _onListen(
      ListenToDonorRequestsEvent event, Emitter<DonorRequestsState> emit) {
    emit(DonorRequestsLoading());
    _getAllUseCase().listen(
          (requests) {
        add(DonorRequestsUpdatedEvent(requests: requests));
      },
      onError: (error) {
        emit(DonorRequestsFailure(error.toString()));
      },
    );
  }

  void _onUpdated(
      DonorRequestsUpdatedEvent event, Emitter<DonorRequestsState> emit) {
    emit(DonorRequestsLoaded(event.requests));
  }
}


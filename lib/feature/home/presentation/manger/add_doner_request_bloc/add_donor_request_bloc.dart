import 'dart:async';
import 'package:blood_bank/feature/home/domain/usecases/add_donor_request_usecase.dart';
import 'package:blood_bank/feature/home/domain/usecases/get_all_donors_use_case.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_event.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class AddDonorRequestBloc
//     extends Bloc<AddDonorRequestEvent, AddDonorRequestState> {
//   final AddDonorRequestUseCase _addUseCase;
//   final GetDonorByIdUseCase _getUseCase;
//   final GetAllDonorRequestsUseCase _getAllUseCase;
//
//
//   AddDonorRequestBloc(
//     this._addUseCase,
//     this._getUseCase,
//     this._getAllUseCase,
//   ) : super(AddDonorRequestInitial()) {
//     on<SubmitDonorRequestEvent>(_onSubmitRequest);
//     on<GetDonorByIdEvent>(_onGetDonor);
//     on<ListenToDonorRequestsEvent>(_onListen);
//     on<DonorRequestsUpdatedEvent>(_onUpdated);
//   }
//
//   Future<void> _onSubmitRequest(
//       SubmitDonorRequestEvent event, Emitter<AddDonorRequestState> emit) async {
//     emit(AddDonorRequestLoading());
//     final res = await _addUseCase(event.request);
//     res.fold(
//       (failure) => emit(AddDonorRequestFailure(failure.message)),
//       (_) => emit(AddDonorRequestSuccess()),
//     );
//   }
//
//   Future<void> _onGetDonor(
//       GetDonorByIdEvent event, Emitter<AddDonorRequestState> emit) async {
//     emit(AddDonorRequestLoading());
//     final res = await _getUseCase(event.userId);
//     res.fold(
//       (failure) => emit(AddDonorRequestFailure(failure.message)),
//       (data) => emit(DonorDataLoaded(data)),
//     );
//   }
//
//   void _onListen(
//       ListenToDonorRequestsEvent event, Emitter<AddDonorRequestState> emit) {
//     emit(DonorRequestsLoading());
//     _getAllUseCase().listen(
//       (requests) {
//         add(DonorRequestsUpdatedEvent(requests));
//       },
//       onError: (error) {
//         emit(DonorRequestsFailure(error.toString()));
//       },
//     );
//   }
//
//   void _onUpdated(
//       DonorRequestsUpdatedEvent event, Emitter<AddDonorRequestState> emit) {
//     emit(DonorRequestsLoaded(event.requests));
//   }
//
// }
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
    res.fold(
          (failure) => emit(DonorRequestsFailure(failure.message)),
          (_) => emit(DonorRequestsSuccess()),
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


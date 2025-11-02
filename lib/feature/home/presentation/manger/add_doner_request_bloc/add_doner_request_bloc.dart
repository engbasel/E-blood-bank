import 'package:blood_bank/core/errors/failures.dart';
import 'package:blood_bank/feature/home/domain/usecases/add_doner_request_usecase.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_doner_request_event.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_doner_request_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddDonerRequestBloc
    extends Bloc<AddDonerRequestEvent, AddDonerRequestState> {
  final AddDonerRequestUseCase _useCase;

  AddDonerRequestBloc(this._useCase) : super(AddDonerRequestInitial()) {
    on<SubmitDonerRequestEvent>(_onSubmitRequest);
  }

  Future<void> _onSubmitRequest(
      SubmitDonerRequestEvent event, Emitter<AddDonerRequestState> emit) async {
    emit(AddDonerRequestLoading());
    try {
      final Either<Failures, void> res = await _useCase(event.request);
      res.fold((failure) {
        emit(AddDonerRequestFailure(failure.message));
      }, (_) {
        emit(AddDonerRequestSuccess());
      });
    } catch (e) {
      emit(AddDonerRequestFailure(e.toString()));
    }
  }
}

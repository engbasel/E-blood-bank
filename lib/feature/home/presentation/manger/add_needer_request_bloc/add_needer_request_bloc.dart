import 'package:blood_bank/feature/home/domain/entities/needer_request_entity.dart';
import 'package:blood_bank/feature/home/domain/usecases/get_accepted_needer_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_bank/feature/home/domain/usecases/add_needer_request_usecase.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_needer_request_bloc/add_needer_request_event.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_needer_request_bloc/add_needer_request_state.dart';
class AddNeederRequestBloc
    extends Bloc<AddNeederRequestEvent, AddNeederRequestState> {
  final AddNeederRequestUseCase addUseCase;
  final GetAcceptedNeederRequestsUseCase getAcceptedUseCase;

  AddNeederRequestBloc(this.addUseCase, this.getAcceptedUseCase)
      : super(AddNeederRequestInitial()) {
    on<SubmitNeederRequestEvent>(_onSubmit);
    on<GetAcceptedNeederRequestsEvent>(_onGetAccepted);
  }

  Future<void> _onSubmit(
      SubmitNeederRequestEvent event, Emitter<AddNeederRequestState> emit) async {
    emit(AddNeederRequestLoading());
    final result = await addUseCase.call(event.request);
    result.fold(
          (failure) => emit(AddNeederRequestFailure(failure.message)),
          (_) {
        emit(AddNeederRequestSuccess());

        add(GetAcceptedNeederRequestsEvent());
      },
    );
  }

  Future<void> _onGetAccepted(
      GetAcceptedNeederRequestsEvent event,
      Emitter<AddNeederRequestState> emit,
      ) async {
    emit(AcceptedNeederRequestsLoading());

    await emit.forEach<List<NeederRequestEntity>>(
      getAcceptedUseCase(),
      onData: (requests) => AcceptedNeederRequestsLoaded(requests),
      onError: (error, _) => AcceptedNeederRequestsFailure(error.toString()),
    );
  }

}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_bank/feature/home/domain/usecases/add_needer_request_usecase.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_needer_request_bloc/add_needer_request_event.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_needer_request_bloc/add_needer_request_state.dart';

class AddNeederRequestBloc
    extends Bloc<AddNeederRequestEvent, AddNeederRequestState> {
  final AddNeederRequestUseCase useCase;

  AddNeederRequestBloc(this.useCase) : super(AddNeederRequestInitial()) {
    on<SubmitNeederRequestEvent>(_onSubmit);
  }

  Future<void> _onSubmit(
      SubmitNeederRequestEvent event, Emitter emitter) async {
    emitter(AddNeederRequestLoading());
    final result = await useCase(event.request);
    result.fold(
      (failure) => emitter(AddNeederRequestFailure(failure.message)),
      (_) => emitter(AddNeederRequestSuccess()),
    );
  }
}

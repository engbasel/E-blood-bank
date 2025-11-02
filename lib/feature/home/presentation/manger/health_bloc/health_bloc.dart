import 'package:blood_bank/feature/home/domain/usecases/get_health_news_usecase.dart';
import 'package:blood_bank/feature/home/presentation/manger/health_bloc/health_event.dart';
import 'package:blood_bank/feature/home/presentation/manger/health_bloc/health_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HealthBloc extends Bloc<HealthEvent, HealthState> {
  final GetHealthNewsUseCase _getHealthNewsUseCase;

  HealthBloc(this._getHealthNewsUseCase) : super(const HealthInitial()) {
    on<FetchHealthNewsEvent>(_onFetchHealthNews);
  }

  Future<void> _onFetchHealthNews(
    FetchHealthNewsEvent event,
    Emitter<HealthState> emit,
  ) async {
    emit(const HealthLoading());

    try {
      final articles = await _getHealthNewsUseCase();
      emit(HealthSuccess(articles));
    } catch (e) {
      emit(HealthError(e.toString()));
    }
  }
}

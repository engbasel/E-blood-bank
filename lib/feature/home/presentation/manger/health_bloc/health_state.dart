import 'package:blood_bank/feature/home/data/model/health_model.dart';

abstract class HealthState {
  const HealthState();
}

class HealthInitial extends HealthState {
  const HealthInitial();
}

class HealthLoading extends HealthState {
  const HealthLoading();
}

class HealthSuccess extends HealthState {
  final List<HealthModel> articles;

  const HealthSuccess(this.articles);
}

class HealthError extends HealthState {
  final String message;

  const HealthError(this.message);
}

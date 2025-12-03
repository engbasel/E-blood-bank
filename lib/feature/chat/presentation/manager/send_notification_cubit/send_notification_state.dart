abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationSending extends NotificationState {}

class NotificationSent extends NotificationState {}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}

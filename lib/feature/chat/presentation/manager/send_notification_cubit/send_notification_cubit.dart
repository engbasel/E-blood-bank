import 'package:bloc/bloc.dart';
import 'package:blood_bank/feature/chat/presentation/manager/send_notification_cubit/send_notification_state.dart';
import 'package:blood_bank/feature/notification/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  Future<void> sendMessageNotification({
    required String receiverId,
    required String title,
    required String body,
    required Map<String, String> data,
  }) async {
    emit(NotificationSending());

    try {
      // 1) Get receiver token
      final doc = await FirebaseFirestore.instance
          .collection("userTokens")
          .doc(receiverId)
          .get();

      if (!doc.exists) {
        emit(NotificationError("Receiver token not found"));
        return;
      }

      final token = doc.data()?["token"];
      if (token == null) {
        emit(NotificationError("Receiver token is null"));
        return;
      }

      // 2) Send notification via your NotificationService
      await NotificationService.instance.sendNotificationToUser(
        token: token,
        title: title,
        body: body,
        data: data,
      );

      emit(NotificationSent());
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}

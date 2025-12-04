import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_bank/feature/chat/data/repo/chat_repo.dart';

part 'send_message_state.dart';

class SendMessageCubit extends Cubit<SendMessageState> {
  final ChatRepository chatRepository;

  SendMessageCubit({required this.chatRepository})
      : super(SendMessageInitial());

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String messageText,
  }) async {
    emit(SendMessageLoading());

    final result = await chatRepository.sendMessage(
      chatId: chatId,
      senderId: senderId,
      receiverId: receiverId,
      messageText: messageText,
    );

    result.fold(
      (failure) => emit(SendMessageError(message: failure.toString())),
      (_) => emit(SendMessageSuccess()),
    );
  }
}

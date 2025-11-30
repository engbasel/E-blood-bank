import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_bank/feature/chat/data/models/message_model.dart';
import 'package:blood_bank/feature/chat/data/repo/chat_repo.dart';

part 'chat_messages_state.dart';

class ChatMessagesCubit extends Cubit<ChatMessagesState> {
  final ChatRepository chatRepository;

  ChatMessagesCubit({required this.chatRepository})
      : super(ChatMessagesInitial());

  void fetchMessages(String chatId) async {
    emit(ChatMessagesLoading());
    final result = await chatRepository.getAllMessages(chatId);
    result.fold(
      (failure) => emit(ChatMessagesError(message: failure.toString())),
      (messages) => emit(ChatMessagesLoaded(messages: messages)),
    );
  }

  void addMessage(MessageModel message) {
    if (state is ChatMessagesLoaded) {
      final currentMessages = (state as ChatMessagesLoaded).messages;
      emit(ChatMessagesLoaded(messages: [...currentMessages, message]));
    }
  }
}

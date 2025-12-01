import 'package:blood_bank/feature/chat/data/repo/chat_repo.dart';
import 'package:blood_bank/feature/chat/presentation/manager/unread_message_cubit/unread_messages_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnreadMessagesCubit extends Cubit<UnreadMessagesState> {
  final ChatRepository chatRepository;

  UnreadMessagesCubit(this.chatRepository) : super(UnreadMessagesInitial());

  void listenToUnreadMessages(String chatId, String currentUserId) {
    emit(UnreadMessagesLoading());

    try {
      chatRepository.getUnreadCount(chatId, currentUserId).listen((count) {
        emit(UnreadMessagesLoaded(count));
      });
    } catch (e) {
      emit(UnreadMessagesError(e.toString()));
    }
  }
}

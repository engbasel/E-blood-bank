import 'package:blood_bank/feature/chat/data/repo/chat_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnreadMessagesCubit extends Cubit<Map<String, int>> {
  final ChatRepository chatRepository;

  UnreadMessagesCubit(this.chatRepository) : super({});

  void listenToAllUnread(String currentUserId, List<String> userIds) {
    for (var userId in userIds) {
      final chatId = chatRepository.generateChatId(currentUserId, userId);

      chatRepository.getUnreadCount(chatId, currentUserId).listen((count) {
        final newState = Map<String, int>.from(state);
        newState[userId] = count;
        emit(newState);
      });
    }
  }
}

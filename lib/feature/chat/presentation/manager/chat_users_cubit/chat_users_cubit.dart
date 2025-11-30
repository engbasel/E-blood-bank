import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_users_state.dart';
import 'package:blood_bank/feature/chat/data/repo/chat_repo.dart';

class ChatUsersCubit extends Cubit<ChatUsersState> {
  final ChatRepository chatRepository;
  final String currentUserId;

  ChatUsersCubit({
    required this.chatRepository,
    required this.currentUserId,
  }) : super(ChatUsersInitial());

  Future<void> fetchAllUsers() async {
    emit(ChatUsersLoading());

    final result =
        await chatRepository.getAllUsersWithLastMessage(currentUserId);

    result.fold(
      (failure) {
        emit(ChatUsersError(failure.toString()));
      },
      (users) {
        emit(ChatUsersLoaded(users));
      },
    );
  }
}

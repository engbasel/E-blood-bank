import 'dart:async';

import 'package:blood_bank/feature/chat/data/repo/chat_repo.dart';
import 'package:blood_bank/feature/chat/presentation/manager/chat_users_cubit/chat_users_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatUsersCubit extends Cubit<ChatUsersState> {
  final ChatRepository chatRepository;
  final String currentUserId;

  StreamSubscription? _subscription;

  ChatUsersCubit({
    required this.chatRepository,
    required this.currentUserId,
  }) : super(ChatUsersInitial());

  void listenToUsers() {
    emit(ChatUsersLoading());

    _subscription = chatRepository
        .getAllUsersWithLastMessageStream(currentUserId)
        .listen((users) {
      emit(ChatUsersLoaded(users));
    }, onError: (error) {
      emit(ChatUsersError(error.toString()));
    });
  }

  void refreshUsers() {
    _subscription?.cancel();
    listenToUsers();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

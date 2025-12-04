import 'dart:async';
import 'package:blood_bank/feature/chat/data/repo/chat_repo.dart';
import 'package:blood_bank/feature/chat/presentation/manager/unread_message_cubit/unread_messages_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnreadMessagesCubit extends Cubit<UnreadMessagesState> {
  final ChatRepository chatRepository;
  final Map<String, StreamSubscription> _subscriptions = {};
  final Map<String, int> _counts = {}; // local storage of unread counts

  UnreadMessagesCubit(this.chatRepository) : super(UnreadMessagesInitial());

  /// Start listening to unread messages for multiple users
  void listenToAllUnread(String currentUserId, List<String> userIds) {
    if (userIds.isEmpty) return;

    emit(UnreadMessagesLoading());

    try {
      for (var otherUserId in userIds) {
        if (_subscriptions.containsKey(otherUserId)) continue;

        // Listen to unread messages using named parameters
        final sub = chatRepository
            .getUnreadMessages(
          currentUserId: currentUserId,
          otherUserId: otherUserId,
        )
            .listen(
          (snapshot) {
            final count = snapshot.docs.length;
            _counts[otherUserId] = count;
            emit(UnreadMessagesLoaded(Map<String, int>.from(_counts)));
          },
          onError: (error) {
            emit(UnreadMessagesError(error.toString()));
          },
        );

        _subscriptions[otherUserId] = sub;
      }
    } catch (e) {
      emit(UnreadMessagesError(e.toString()));
    }
  }

  /// Stop listening to a user
  void stopListening(String userId) {
    _subscriptions[userId]?.cancel();
    _subscriptions.remove(userId);
    _counts.remove(userId);
    emit(UnreadMessagesLoaded(Map<String, int>.from(_counts)));
  }

  @override
  Future<void> close() {
    for (var sub in _subscriptions.values) {
      sub.cancel();
    }
    return super.close();
  }
}

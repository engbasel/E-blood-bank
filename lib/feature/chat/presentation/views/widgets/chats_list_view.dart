import 'package:blood_bank/feature/chat/presentation/manager/chat_users_cubit/chat_users_cubit.dart';
import 'package:blood_bank/feature/chat/presentation/manager/chat_users_cubit/chat_users_state.dart';
import 'package:blood_bank/feature/chat/presentation/manager/unread_message_cubit/unread_messages_cubit.dart';
import 'package:blood_bank/feature/chat/presentation/manager/unread_message_cubit/unread_messages_state.dart';
import 'package:blood_bank/feature/chat/presentation/views/chat_screen_view.dart';
import 'package:blood_bank/feature/chat/presentation/views/widgets/chats_list_view_item.dart';
import 'package:blood_bank/feature/chat/presentation/views/widgets/empty_chat_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsListView extends StatelessWidget {
  const ChatsListView({super.key, required this.currentUserId});
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final chatUsersCubit = context.watch<ChatUsersCubit>();
    final unreadCubit = context.read<UnreadMessagesCubit>();

    return BlocBuilder<ChatUsersCubit, ChatUsersState>(
      builder: (context, state) {
        if (state is ChatUsersLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ChatUsersError) {
          return Center(child: Text(state.message));
        }

        if (state is ChatUsersLoaded) {
          final users = state.users;
          final userIds = users.map((u) => u.userId).toList();

          unreadCubit.listenToAllUnread(currentUserId, userIds);
          if (users.isEmpty) {
            return const Center(child: EmptyChatAnimation());
          }

          return BlocBuilder<UnreadMessagesCubit, UnreadMessagesState>(
            builder: (context, unreadState) {
              int getUnreadCount(String userId) {
                if (unreadState is UnreadMessagesLoaded) {
                  return unreadState.counts[userId] ?? 0;
                }
                return 0;
              }

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (_, index) {
                  final user = users[index];
                  final unreadCount = getUnreadCount(user.userId);

                  return ChatListViewItem(
                    currentUserId: currentUserId,
                    senderId: user.lastMessageSenderId,
                    imageUrl: user.imageUrl,
                    name: user.name,
                    lastMessage: user.lastMessage.isEmpty
                        ? "Say hi 👋"
                        : user.lastMessage,
                    lastMessageTime: user.lastMessageTime,
                    lastMessageSeen: user.lastMessageSeen,
                    unreadCount: unreadCount,
                    onTap: () {
                      final chatId = chatUsersCubit.chatRepository
                          .generateChatId(currentUserId, user.userId);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            contactNumber: user.contactNumber ?? "",
                            onUpdateRequired: chatUsersCubit.listenToUsers,
                            chatId: chatId,
                            userName: user.name,
                            userImage: user.imageUrl,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}

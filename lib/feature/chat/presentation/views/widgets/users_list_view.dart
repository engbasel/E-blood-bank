import 'dart:developer';

import 'package:blood_bank/feature/chat/presentation/manager/chat_users_cubit/chat_users_cubit.dart';
import 'package:blood_bank/feature/chat/presentation/manager/chat_users_cubit/chat_users_state.dart';
import 'package:blood_bank/feature/chat/presentation/views/chat_screen_view.dart';
import 'package:blood_bank/feature/chat/presentation/views/widgets/users_list_view_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersListView extends StatelessWidget {
  const UsersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatUsersCubit, ChatUsersState>(
      builder: (context, state) {
        if (state is ChatUsersLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChatUsersError) {
          return Center(child: Text(state.message));
        } else if (state is ChatUsersLoaded) {
          final users = state.users;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              log("User: ${user.name}, ImageUrl: ${user.imageUrl}");
              return UserListViewItem(
                imageUrl: user.imageUrl,
                name: user.name,
                lastMessage:
                    user.lastMessage.isEmpty ? "Say hi 👋" : user.lastMessage,
                lastMessageTime: user.lastMessageTime,
                lastMessageSeen: user.lastMessageSeen,
                onTap: () {
                  log("clicked clicked ");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        userName: user.name,
                        userImage: user.imageUrl,
                      ),
                    ),
                  );
                },
              );
            },
          );
        } else {
          return const Text("else case");
        }
      },
    );
  }
}

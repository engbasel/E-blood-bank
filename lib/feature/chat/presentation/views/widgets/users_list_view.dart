import 'package:blood_bank/core/helper_function/generate_chat_id_fun.dart';
import 'package:blood_bank/feature/chat/data/repo/chat_repo.dart';
import 'package:blood_bank/feature/chat/presentation/views/chat_screen_view.dart';
import 'package:blood_bank/feature/chat/presentation/views/widgets/users_list_view_item.dart';
import 'package:flutter/material.dart';

class UsersListView extends StatelessWidget {
  const UsersListView(
      {super.key, required this.chatRepo, required this.currentUserId});
  final ChatRepository chatRepo;
  final String currentUserId;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: chatRepo.getUsersWithoutChatStream(currentUserId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data!;

        if (users.isEmpty) {
          return const Center(
            child: Text(
              "No users available to chat with 🙌",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];

            return UserListItem(
              imageUrl: user["photoUrl"] ??
                  "https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?size=338&ext=jpg",
              name: user["name"],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      contactNumber: user['contactNumber'] ?? "",
                      chatId: generateChatId(
                        currentUserId,
                        user['uId'],
                      ),
                      userName: user["name"],
                      userImage: user["photoUrl"] ??
                          "https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?size=338&ext=jpg",
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
}

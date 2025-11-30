import 'package:blood_bank/feature/chat/presentation/views/widgets/users_list_view_item.dart';
import 'package:flutter/material.dart';

class UsersListView extends StatelessWidget {
  const UsersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return UserListViewItem(
            imageUrl:
                "https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?semt=ais_hybrid&w=740&q=80",
            name: 'Mohamed Hussien',
            lastMessage: "i finished chat item fjhjfhds hfjhfhfdhjh",
            lastMessageTime: DateTime(
              DateTime.now().hour,
            ),
            lastMessageSeen: true,
          );
        });
  }
}

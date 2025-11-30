import 'package:blood_bank/feature/chat/presentation/views/widgets/users_list_view_item.dart';
import 'package:flutter/material.dart';

class ChatViewBody extends StatelessWidget {
  const ChatViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 8,
        ),
        UserListViewItem(
          userEmail: "mohaemd@gmail.com",
          userName: "Mohamed Hussien",
          userImageUrl:
              "https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?semt=ais_hybrid&w=740&q=80",
        ),
        UserListViewItem(
          userEmail: "mohaemd@gmail.com",
          userName: "Mohamed Hussien",
          userImageUrl:
              "https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?semt=ais_hybrid&w=740&q=80",
        ),
        UserListViewItem(
          userEmail: "mohaemd@gmail.com",
          userName: "Mohamed Hussien",
          userImageUrl:
              "https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?semt=ais_hybrid&w=740&q=80",
        ),
        UserListViewItem(
          userEmail: "mohaemd@gmail.com",
          userName: "Mohamed Hussien",
          userImageUrl:
              "https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?semt=ais_hybrid&w=740&q=80",
        ),
      ],
    );
  }
}

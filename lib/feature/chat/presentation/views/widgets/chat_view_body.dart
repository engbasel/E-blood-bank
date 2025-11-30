import 'package:blood_bank/feature/chat/presentation/views/widgets/users_list_view.dart';
import 'package:flutter/material.dart';

class ChatViewBody extends StatelessWidget {
  const ChatViewBody({super.key, required this.currentUserId});
  final String currentUserId;
  @override
  Widget build(BuildContext context) {
    return UsersListView(
      currentUserId: currentUserId,
    );
  }
}

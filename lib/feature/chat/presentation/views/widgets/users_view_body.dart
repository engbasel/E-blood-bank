import 'package:blood_bank/feature/chat/data/repo/chat_repo_impl.dart';
import 'package:blood_bank/feature/chat/presentation/views/widgets/users_list_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersViewBody extends StatelessWidget {
  const UsersViewBody({super.key, required this.currentUserId});
  final String currentUserId;
  @override
  Widget build(BuildContext context) {
    return UsersListView(
      chatRepo: ChatRepositoryImpl(
        firestore: FirebaseFirestore.instance,
      ),
      currentUserId: currentUserId,
    );
  }
}

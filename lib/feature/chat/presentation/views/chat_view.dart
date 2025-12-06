import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/chat/data/repo/chat_repo_impl.dart';
import 'package:blood_bank/feature/chat/presentation/manager/chat_users_cubit/chat_users_cubit.dart';
import 'package:blood_bank/feature/chat/presentation/manager/send_notification_cubit/send_notification_cubit.dart';
import 'package:blood_bank/feature/chat/presentation/manager/unread_message_cubit/unread_messages_cubit.dart';
import 'package:blood_bank/feature/chat/presentation/views/users_view.dart';
import 'package:blood_bank/feature/chat/presentation/views/widgets/chat_view_body.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key, required this.currentUserId});
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatUsersCubit>(
          create: (context) => ChatUsersCubit(
            chatRepository:
                ChatRepositoryImpl(firestore: FirebaseFirestore.instance),
            currentUserId: currentUserId,
          )..listenToUsers(),
        ),
        BlocProvider<UnreadMessagesCubit>(
          create: (context) => UnreadMessagesCubit(
            ChatRepositoryImpl(firestore: FirebaseFirestore.instance),
          ),
        ),
        BlocProvider(create: (context) => NotificationCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'chat_title'.tr(context),
            style: TextStyles.semiBold19.copyWith(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          elevation: 4,
          automaticallyImplyLeading: false,
        ),
        body: ChatViewBody(
          currentUserId: currentUserId,
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 48.0),
          child: SizedBox(
            width: 64,
            height: 64,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UsersView()),
                );
              },
              backgroundColor: AppColors.primaryColor,
              shape: const CircleBorder(),
              elevation: 6,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

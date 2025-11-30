import 'package:blood_bank/feature/chat/data/repo/chat_repo_impl.dart';
import 'package:blood_bank/feature/chat/presentation/manager/chat_messages_cubit/chat_messages_cubit.dart';
import 'package:blood_bank/feature/chat/presentation/manager/chat_users_cubit/chat_users_cubit.dart';
import 'package:blood_bank/feature/chat/presentation/manager/send_message_cubit/send_message_cubit.dart';
import 'package:blood_bank/feature/chat/presentation/views/widgets/message_bubble.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  final String userName;
  final String userImage;
  final String chatId;
  final ChatUsersCubit chatUsersCubit;

  ChatScreen({
    super.key,
    required this.userName,
    required this.userImage,
    required this.chatId,
    required this.chatUsersCubit,
  });

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final chatRepo = ChatRepositoryImpl(firestore: FirebaseFirestore.instance);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ChatMessagesCubit(chatRepository: chatRepo)
            ..fetchMessages(chatId),
        ),
        BlocProvider(
          create: (_) => SendMessageCubit(chatRepository: chatRepo),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          titleSpacing: -10,
          leadingWidth: 35,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              const SizedBox(width: 10),
              CircleAvatar(backgroundImage: NetworkImage(userImage)),
              const SizedBox(width: 10),
              Text(userName, style: const TextStyle(color: Colors.black)),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatMessagesCubit, ChatMessagesState>(
                builder: (context, state) {
                  if (state is ChatMessagesLoading) {
                    return SizedBox();
                  } else if (state is ChatMessagesError) {
                    return Center(child: Text(state.message));
                  } else if (state is ChatMessagesLoaded) {
                    final messages = state.messages.reversed.toList();

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isMe = message.senderId == currentUserId;
                        return MessageBubble(message: message, isMe: isMe);
                      },
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
            _buildInputField(context, currentUserId),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context, String currentUserId) {
    final TextEditingController controller = TextEditingController();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Type a message...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          BlocConsumer<SendMessageCubit, SendMessageState>(
            listener: (context, state) {
              if (state is SendMessageSuccess) {
                controller.clear();
                context.read<ChatMessagesCubit>().fetchMessages(chatId);
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
                // Refresh users list to update last message
                chatUsersCubit.refreshUsers();
              } else if (state is SendMessageError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  final text = controller.text.trim();
                  if (text.isEmpty) return;

                  final receiverId =
                      chatId.split("_").firstWhere((id) => id != currentUserId);

                  context.read<SendMessageCubit>().sendMessage(
                        chatId: chatId,
                        senderId: currentUserId,
                        receiverId: receiverId,
                        messageText: text,
                      );
                },
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primaryColor,
                  child: state is SendMessageLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2)
                      : const Icon(Icons.send, color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

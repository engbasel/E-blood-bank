import 'package:blood_bank/feature/chat/data/repo/chat_repo_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_bank/feature/chat/presentation/manager/chat_messages_cubit/chat_messages_cubit.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/feature/chat/presentation/views/widgets/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  final String userName;
  final String userImage;
  final String chatId;

  ChatScreen({
    super.key,
    required this.userName,
    required this.userImage,
    required this.chatId,
  });

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return BlocProvider(
      create: (_) => ChatMessagesCubit(
          chatRepository:
              ChatRepositoryImpl(firestore: FirebaseFirestore.instance))
        ..fetchMessages(chatId),
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
                    return const Center(child: CircularProgressIndicator());
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
          GestureDetector(
            onTap: () async {
              // final text = controller.text.trim();
              // if (text.isEmpty) return;

              // // إرسال الرسالة عبر Cubit
              // final message = MessageModel(
              //   senderId: currentUserId,
              //   receiverId:
              //       chatId.split("_").firstWhere((id) => id != currentUserId),
              //   text: text,
              //   timestamp: DateTime.now(),
              // );

              // cubit.addMessage(message); // إضافة مؤقتة للـ UI
              // controller.clear();

              // await cubit.chatRepository.sendMessage(
              //   chatId: chatId,
              //   senderId: message.senderId,
              //   receiverId: message.receiverId,
              //   messageText: message.text,
              // );

              // // تمرير الـ scroll لأحدث رسالة
              // _scrollController.animateTo(
              //   0,
              //   duration: const Duration(milliseconds: 300),
              //   curve: Curves.easeOut,
              // );
            },
            child: CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primaryColor,
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

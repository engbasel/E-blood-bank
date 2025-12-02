import 'package:blood_bank/feature/chat/data/models/message_model.dart';
import 'package:blood_bank/feature/chat/data/repo/chat_repo_impl.dart';
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("chats")
                    .doc(chatId)
                    .collection("messages")
                    .orderBy("timestamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text("Error loading messages"));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No messages yet"));
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    reverse: true,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;

                      final message = MessageModel(
                        senderId: data["senderId"],
                        receiverId: data["receiverId"],
                        text: data["text"],
                        timestamp: data["timestamp"] == null
                            ? DateTime.now()
                            : (data["timestamp"] as Timestamp).toDate(),
                      );

                      final isMe = message.senderId == currentUserId;

                      return MessageBubble(message: message, isMe: isMe);
                    },
                  );
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

                /// scroll to bottom
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );

                /// update last message in users list
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
                          color: Colors.white,
                          strokeWidth: 2,
                        )
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

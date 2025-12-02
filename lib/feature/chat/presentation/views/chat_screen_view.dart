import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/feature/chat/data/models/message_model.dart';
import 'package:blood_bank/feature/chat/data/repo/chat_repo_impl.dart';
import 'package:blood_bank/feature/chat/presentation/manager/send_message_cubit/send_message_cubit.dart';
import 'package:blood_bank/feature/chat/presentation/views/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String userImage;
  final String chatId;

  const ChatScreen({
    super.key,
    required this.userName,
    required this.userImage,
    required this.chatId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ScrollController _scrollController;
  late final TextEditingController _controller;
  late final SendMessageCubit sendMessageCubit;
  final chatRepo = ChatRepositoryImpl(firestore: FirebaseFirestore.instance);

  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = TextEditingController();
    markMessagesAsSeen();
    sendMessageCubit = SendMessageCubit(chatRepository: chatRepo);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    sendMessageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sendMessageCubit,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(child: _buildMessagesList()),
            _buildInputField(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: BackButton(color: Colors.black),
      title: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(widget.userImage)),
          const SizedBox(width: 10),
          Text(widget.userName, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("chats")
          .doc(widget.chatId)
          .collection("messages")
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text("No messages yet"));
        }

        return ListView.builder(
          controller: _scrollController,
          reverse: true,
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          itemBuilder: (_, index) {
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
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Type a message...",
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 10),
          BlocConsumer<SendMessageCubit, SendMessageState>(
            listener: (context, state) {
              if (state is SendMessageSuccess) {
                _controller.clear();

                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                );
              }
            },
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  final text = _controller.text.trim();
                  if (text.isEmpty) return;

                  final receiverId = widget.chatId
                      .split("_")
                      .firstWhere((id) => id != currentUserId);

                  sendMessageCubit.sendMessage(
                    chatId: widget.chatId,
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

  void markMessagesAsSeen() async {
    final chatId = widget.chatId;
    final batch = FirebaseFirestore.instance.batch();

    final unreadMessages = await FirebaseFirestore.instance
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .where("receiverId", isEqualTo: currentUserId)
        .where("isSeen", isEqualTo: false)
        .get();

    for (var doc in unreadMessages.docs) {
      batch.update(doc.reference, {"isSeen": true});
    }

    await batch.commit();
  }
}

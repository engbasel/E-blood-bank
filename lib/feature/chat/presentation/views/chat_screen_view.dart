import 'package:blood_bank/feature/chat/presentation/views/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/feature/chat/data/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart'; // مهم عشان نجيب uid

class ChatScreen extends StatelessWidget {
  final String userName;
  final String userImage;

  /// Messages from Firestore or Cubit
  final List<MessageModel>? messages;

  ChatScreen({
    super.key,
    required this.userName,
    required this.userImage,
    this.messages,
  });

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    final List<MessageModel> chatMessages = messages ??
        [
          MessageModel(
            senderId: currentUserId,
            receiverId: "user456",
            text: "Hey! 👋",
            timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          ),
          MessageModel(
            senderId: "user456",
            receiverId: currentUserId,
            text: "Hello! How are you?",
            timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
          ),
          MessageModel(
            senderId: currentUserId,
            receiverId: "user456",
            text: "I'm good! Working on the chat UI now 😊",
            timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
          ),
          MessageModel(
            senderId: "user456",
            receiverId: currentUserId,
            text: "Nice! The UI is looking great 🔥",
            timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          ),
          MessageModel(
            senderId: currentUserId,
            receiverId: "user456",
            text: "Thanks bro 💪",
            timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
          ),
        ];

    return Scaffold(
      backgroundColor: Colors.grey[200],

      // ---------------- APP BAR ----------------
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
            CircleAvatar(
              backgroundImage: NetworkImage(userImage),
            ),
            const SizedBox(width: 10),
            Text(
              userName,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),

      // ---------------- MESSAGES LIST ----------------
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              reverse: true,
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                // important: reverse the list manually
                final message = chatMessages[chatMessages.length - 1 - index];

                final isMe = message.senderId == currentUserId;

                return MessageBubble(
                  message: message,
                  isMe: isMe,
                );
              },
            ),
          ),

          // ---------------- INPUT FIELD ----------------
          _buildInputField(context, currentUserId),
        ],
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
            onTap: () {
              // TODO: send msg to Firestore
              print("Send: ${controller.text}");
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

//--------------------------------------------------------------------

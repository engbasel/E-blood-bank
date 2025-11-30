import 'package:flutter/material.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/feature/chat/data/models/message_model.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatelessWidget {
  final String userName;
  final String userImage;

  /// Messages from Firestore or Cubit
  final List<MessageModel>? messages;

  const ChatScreen({
    super.key,
    required this.userName,
    required this.userImage,
    this.messages,
  });

  @override
  Widget build(BuildContext context) {
    final List<MessageModel> chatMessages = messages ??
        [
          MessageModel(
            senderId: "me123",
            receiverId: "user456",
            text: "Hey! 👋",
            timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          ),
          MessageModel(
            senderId: "user456",
            receiverId: "me123",
            text: "Hello! How are you?",
            timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
          ),
          MessageModel(
            senderId: "me123",
            receiverId: "user456",
            text: "I'm good! Working on the chat UI now 😊",
            timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
          ),
          MessageModel(
            senderId: "user456",
            receiverId: "me123",
            text: "Nice! The UI is looking great 🔥",
            timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          ),
          MessageModel(
            senderId: "me123",
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
              padding: const EdgeInsets.all(12),
              reverse: true,
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                final message = chatMessages[chatMessages.length - 1 - index];

                final isMe = message.senderId ==
                    "CURRENT_USER_ID"; // TODO: Replace with `FirebaseAuth.instance.currentUser!.uid`

                return MessageBubble(
                  message: message,
                  isMe: isMe,
                );
              },
            ),
          ),

          // ---------------- INPUT FIELD ----------------
          _buildInputField(context),
        ],
      ),
    );
  }

  Widget _buildInputField(BuildContext context) {
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
              // TODO: Send Message
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

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final time = DateFormat("hh:mm a").format(message.timestamp);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft:
                isMe ? const Radius.circular(12) : const Radius.circular(0),
            bottomRight:
                isMe ? const Radius.circular(0) : const Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              time,
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white70 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

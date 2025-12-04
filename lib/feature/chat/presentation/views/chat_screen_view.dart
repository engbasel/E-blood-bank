import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/feature/chat/data/models/message_model.dart';
import 'package:blood_bank/feature/chat/data/repo/chat_repo_impl.dart';
import 'package:blood_bank/feature/chat/presentation/manager/send_message_cubit/send_message_cubit.dart';
import 'package:blood_bank/feature/chat/presentation/manager/send_notification_cubit/send_notification_cubit.dart';
import 'package:blood_bank/feature/chat/presentation/views/widgets/empty_chat_animation.dart';
import 'package:blood_bank/feature/chat/presentation/views/widgets/message_bubble.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String userImage;
  final String chatId;
  final VoidCallback? onUpdateRequired;
  const ChatScreen({
    super.key,
    required this.userName,
    required this.userImage,
    required this.chatId,
    this.onUpdateRequired,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ScrollController _scrollController;
  late final TextEditingController _controller;
  late final SendMessageCubit sendMessageCubit;
  late final NotificationCubit notificationCubit;
  final chatRepo = ChatRepositoryImpl(firestore: FirebaseFirestore.instance);

  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  late final String receiverId;

  String? _messageTextForNotification;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = TextEditingController();

    receiverId =
        widget.chatId.split("_").firstWhere((id) => id != currentUserId);

    markMessagesAsSeen();
    sendMessageCubit = SendMessageCubit(chatRepository: chatRepo);
    notificationCubit = NotificationCubit();
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
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sendMessageCubit),
        BlocProvider.value(value: notificationCubit),
      ],
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
      titleSpacing: 0,
      leading: BackButton(color: Colors.black),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(backgroundImage: NetworkImage(widget.userImage)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.userName,
              style: const TextStyle(color: Colors.black),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
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
          return EmptyChatAnimation();
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey.shade300, width: 0.5),
                  ),
                  child: TextField(
                    controller: _controller,
                    maxLines: 5,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      hintText: "hint_Text".tr(context),
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: InputBorder.none,
                      suffixIcon:
                          Icon(Icons.mood_outlined, color: Colors.grey[500]),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            BlocConsumer<SendMessageCubit, SendMessageState>(
              listener: (context, state) {
                if (state is SendMessageSuccess) {
                  _controller.clear();
//-------------------------- Notification Sending ----------------
                  if (_messageTextForNotification != null) {
                    context.read<NotificationCubit>().sendMessageNotification(
                      receiverId: receiverId,
                      title: "New Message From ${widget.userName}",
                      body: "Message: $_messageTextForNotification!",
                      data: {
                        "chat_id": widget.chatId,
                        "sender_id": currentUserId,
                      },
                    );
                    _messageTextForNotification = null;
                  }
//---------------------------------------------------------------
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  );
                  if (widget.onUpdateRequired != null) {
                    widget.onUpdateRequired!();
                  }
                }
              },
              builder: (context, state) {
                final bool isLoading = state is SendMessageLoading;

                return GestureDetector(
                  onTap: isLoading
                      ? null
                      : () {
                          final text = _controller.text.trim();
                          if (text.isEmpty) return;

                          _messageTextForNotification = text;

                          sendMessageCubit.sendMessage(
                            chatId: widget.chatId,
                            senderId: currentUserId,
                            receiverId: receiverId,
                            messageText: text,
                          );
                        },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.4),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.send,
                              color: Colors.white, size: 22),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void markMessagesAsSeen() async {
    final chatDocRef =
        FirebaseFirestore.instance.collection("chats").doc(widget.chatId);
    final messagesRef = chatDocRef.collection("messages");

    final unreadMessages = await messagesRef
        .where("receiverId", isEqualTo: currentUserId)
        .where("isSeen", isEqualTo: false)
        .get();

    if (unreadMessages.docs.isEmpty) return;

    final batch = FirebaseFirestore.instance.batch();

    for (var doc in unreadMessages.docs) {
      batch.update(doc.reference, {"isSeen": true});
    }

    batch.update(chatDocRef, {"lastMessageSeen": true});

    await batch.commit();

    widget.onUpdateRequired?.call();
  }
}

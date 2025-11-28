import 'package:blood_bank/feature/chat/presentation/views/widgets/chat_list_view_item.dart';
import 'package:flutter/material.dart';

class ChatViewBody extends StatelessWidget {
  const ChatViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // محاكاة لـ (max-w-xl w-full bg-white shadow-2xl rounded-xl)
      constraints: const BoxConstraints(maxWidth: 600),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ChatListItem(
            avatarText: 'M.H',
            name: 'Mohamed Hussien',
            lastMessage: 'I just finished chat item ....',
            timestamp: '10:30 am',
            unreadCount: 3,
            isOnline: true,
            isRead: true,
          ),
          ChatListItem(
            avatarText: 'M.H',
            name: 'Mohamed Hussien',
            lastMessage: 'I just finished chat item ....',
            timestamp: '10:30 am',
            unreadCount: 3,
            isOnline: true,
            isRead: true,
          ),
          ChatListItem(
            avatarText: 'M.H',
            name: 'Mohamed Hussien',
            lastMessage: 'I just finished chat item ....',
            timestamp: '10:30 am',
            unreadCount: 3,
            isOnline: true,
            isRead: true,
          ),
          ChatListItem(
            avatarText: 'M.H',
            name: 'Mohamed Hussien',
            lastMessage: 'I just finished chat item ....',
            timestamp: '10:30 am',
            unreadCount: 3,
            isOnline: true,
            isRead: true,
          ),
        ],
      ),
    );
  }
}

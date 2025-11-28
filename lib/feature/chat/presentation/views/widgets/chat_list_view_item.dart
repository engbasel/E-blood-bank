import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ChatListItem extends StatelessWidget {
  final String avatarText;
  final String name;
  final String lastMessage;
  final String timestamp;
  final int unreadCount;
  final bool isOnline;
  final bool isRead;

  const ChatListItem({
    super.key,
    required this.avatarText,
    required this.name,
    required this.lastMessage,
    required this.timestamp,
    this.unreadCount = 0,
    this.isOnline = false,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: AppColors.primaryColor.withOpacity(0.1), width: 2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAvatarWithStatus(),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900, // Extrabold
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                _buildLastMessagePreview(),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                timestamp,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: unreadCount > 0
                      ? AppColors.primaryColor
                      : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              if (unreadCount > 0) _buildUnreadBadge(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarWithStatus() {
    return Stack(
      children: [
        // محاكاة لـ (w-16 h-16 rounded-full border-3 border-primary shadow-md)
        CircleAvatar(
          radius: 32,
          backgroundColor:
              AppColors.primaryColor.withOpacity(0.1), // لون خلفية placeholder
          child: Text(
            avatarText,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        if (isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.green.shade500,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLastMessagePreview() {
    const Color readStatusColor = Color(0xFF3B82F6);

    return Row(
      children: [
        Icon(
          isRead ? Icons.done_all : Icons.done,
          size: 18,
          color: isRead ? readStatusColor : Colors.grey.shade400, //
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            lastMessage,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildUnreadBadge() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.4),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        unreadCount.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

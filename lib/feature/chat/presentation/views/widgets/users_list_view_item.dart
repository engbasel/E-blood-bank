import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserListViewItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String lastMessage;
  final DateTime? lastMessageTime;
  final bool lastMessageSeen;
  final VoidCallback? onTap;
  final String lastMessageSenderId;
  final String currentUserId;

  const UserListViewItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageSeen,
    this.onTap,
    required this.lastMessageSenderId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    String formattedTime = "";
    if (lastMessageTime != null) {
      formattedTime = DateFormat('hh:mm a').format(lastMessageTime!);
    }

    bool isMyMessage = lastMessageSenderId == currentUserId;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: CircleAvatar(
          radius: 25,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const CircularProgressIndicator(strokeWidth: 2),
              errorWidget: (context, url, error) => Image.network(
                "https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?size=338&ext=jpg",
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Row(
          children: [
            if (isMyMessage && lastMessage != "Say hi 👋")
              Icon(
                Icons.done_all,
                size: 18,
                color: lastMessageSeen ? Colors.blue : Colors.grey,
              ),
            Expanded(
              child: Text(
                lastMessage.isNotEmpty ? lastMessage : "Say hi 👋",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        trailing: Text(
          lastMessageTime == null ? "" : formattedTime,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

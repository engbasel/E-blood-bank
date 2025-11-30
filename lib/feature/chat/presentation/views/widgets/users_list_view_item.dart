import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserListViewItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String lastMessage;
  final DateTime? lastMessageTime;
  final bool lastMessageSeen;

  const UserListViewItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageSeen,
  });

  @override
  Widget build(BuildContext context) {
    String formattedTime = "";

    if (lastMessageTime != null) {
      formattedTime = DateFormat('hh:mm a').format(lastMessageTime!);
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
          // Seen icon
          if (lastMessage != "Say hi 👋")
            Icon(
              Icons.done_all,
              size: 18,
              color: lastMessageSeen ? Colors.blue : Colors.grey,
            ),
          const SizedBox(width: 5),

          // Last message text
          Expanded(
            child: Text(
              lastMessage.isEmpty ? "No messages yet" : lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),

      // Time of last message
      trailing: Text(
        lastMessageTime == null ? "" : formattedTime,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),

      onTap: () {
        // open chat screen
      },
    );
  }
}

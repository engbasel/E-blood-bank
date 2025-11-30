import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserListViewItem extends StatelessWidget {
  const UserListViewItem({
    super.key,
    required this.userImageUrl,
    required this.userName,
    required this.userEmail,
  });

  final String userImageUrl, userName, userEmail;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      // padding: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4), // الظل تحت الكارد
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 26,
          backgroundImage: CachedNetworkImageProvider(userImageUrl),
        ),
        title: Text(userName, style: TextStyles.semiBold19),
        subtitle: Text(
          userEmail,
          style: TextStyles.regular13,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {
          // open profile details
        },
      ),
    );
  }
}

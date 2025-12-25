import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HomeUserImage extends StatelessWidget {
  const HomeUserImage({
    super.key,
    required this.photoUrl,
  });

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.white,
      child: ClipOval(
        child: photoUrl != null && photoUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: photoUrl!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.grey,
                ),
              )
            : const Icon(
                Icons.person,
                size: 30,
                color: Colors.grey,
              ),
      ),
    );
  }
}

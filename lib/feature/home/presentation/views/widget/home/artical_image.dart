import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ArticleImage extends StatelessWidget {
  const ArticleImage({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: CachedNetworkImage(
        imageUrl: image,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 180,
          width: double.infinity,
          color: Colors.grey[100],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => CachedNetworkImage(
          imageUrl:
              "https://c1.wallpaperflare.com/preview/11/461/86/blood-cells-red-medical.jpg",
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Container(
            height: 180,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

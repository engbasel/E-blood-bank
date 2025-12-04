import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyChatAnimation extends StatelessWidget {
  const EmptyChatAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 120,
        ),
        Lottie.asset(
          Assets.imagesEmpty1,
          width: 200,
          height: 100,
          fit: BoxFit.cover,
          repeat: true,
        ),
      ],
    );
  }
}

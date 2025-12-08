import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
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
        const SizedBox(height: 150.0,),
        Text('no_chats_yet'.tr(context),
          style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 18
          ),
        ),
      ],
    );
  }
}

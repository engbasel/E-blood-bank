import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 6.0,
        valueColor: AlwaysStoppedAnimation<Color>(
          AppColors.backgroundColor,
        ),
        backgroundColor: AppColors.primaryColor
            .withValues(alpha: 0.3),
      ),
    );
  }
}

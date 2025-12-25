import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HealthLoadingWidget extends StatelessWidget {
  const HealthLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Skeletonizer(
            child: Container(
              width: 280,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:blood_bank/constants.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DonationStatsCardSkeleton extends StatelessWidget {
  const DonationStatsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding - 3),
      child: Skeletonizer(
        enabled: true,
        effect: ShimmerEffect(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
        ),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonHeader(),
                SizedBox(height: 16),
                _SkeletonStatBar(),
                SizedBox(height: 16),
                _SkeletonStatBar(),
                SizedBox(height: 16),
                _SkeletonStatBar(),
                SizedBox(height: 16),
                _SkeletonStatBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Title Placeholder
class _SkeletonHeader extends StatelessWidget {
  const _SkeletonHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

class _SkeletonStatBar extends StatelessWidget {
  const _SkeletonStatBar();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Icon placeholder
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),

            // Title placeholder
            Container(
              width: 90,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const Spacer(),

            // Value placeholder
            Container(
              width: 30,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Progress bar placeholder full width minus Row paddings
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            height: 8,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

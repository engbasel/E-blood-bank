import 'package:blood_bank/constants.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/donation_stat_bar.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class CustomStatsWidget extends StatelessWidget {
  final int donors;
  final int needers;
  final int inProgress;
  final int successful;
  final int maxValue;

  const CustomStatsWidget({
    super.key,
    required this.donors,
    required this.needers,
    required this.inProgress,
    required this.successful,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding - 3),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'donation_analytics'.tr(context),
                style: TextStyles.semiBold16,
              ),
              const SizedBox(height: 16),
              DonationStatBar(
                icon: Icons.bloodtype,
                title: 'donors'.tr(context),
                value: donors,
                maxValue: maxValue,
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: 16),
              DonationStatBar(
                icon: Icons.people,
                title: 'needers'.tr(context),
                value: needers,
                maxValue: maxValue,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              DonationStatBar(
                icon: Icons.sync,
                title: 'in_progress'.tr(context),
                value: inProgress,
                maxValue: maxValue,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              DonationStatBar(
                icon: Icons.check_circle,
                title: 'successful'.tr(context),
                value: successful,
                maxValue: maxValue,
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

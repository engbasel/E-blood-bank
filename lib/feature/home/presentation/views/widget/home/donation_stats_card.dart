import 'package:blood_bank/constants.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/donation_stat_bar.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class DonationStatsCard extends StatelessWidget {
  const DonationStatsCard({super.key});

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'donation_analytics'.tr(context),
                    style: TextStyles.semiBold16,
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              DonationStatBar(
                icon: Icons.bloodtype,
                title: 'donors'.tr(context),
                value: 120,
                maxValue: 150,
                color: AppColors.primaryColor,
              ),
              SizedBox(height: 16),
              DonationStatBar(
                icon: Icons.people,
                title: 'needers'.tr(context),
                value: 85,
                maxValue: 150,
                color: Colors.blue,
              ),
              SizedBox(height: 16),
              DonationStatBar(
                icon: Icons.sync,
                title: 'in_progress'.tr(context),
                value: 42,
                maxValue: 150,
                color: Colors.orange,
              ),
              SizedBox(height: 16),
              DonationStatBar(
                icon: Icons.check_circle,
                title: 'successful'.tr(context),
                value: 97,
                maxValue: 150,
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

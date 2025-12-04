import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class CallIcon extends StatelessWidget {
  final String phoneNumber;

  const CallIcon({
    super.key,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: IconButton(
        icon: const Icon(Icons.phone, color: AppColors.primaryColor, size: 28),
        onPressed: () {
          _makePhoneCall(context, phoneNumber);
        },
      ),
    );
  }

  Future<void> _makePhoneCall(BuildContext context, String number) async {
    final Uri callUri = Uri(scheme: 'tel', path: number);

    if (await canLaunchUrl(callUri)) {
      await launchUrl(
        callUri,
        mode: LaunchMode.platformDefault,
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("alert".tr(context)),
          content: Text("could_not_launch_call".tr(context)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("ok".tr(context)),
            ),
          ],
        ),
      );
    }
  }
}

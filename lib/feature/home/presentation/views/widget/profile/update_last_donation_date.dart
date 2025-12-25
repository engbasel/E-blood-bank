import 'package:blood_bank/core/helper_function/get_user.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/auth/data/models/user_model.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/up_donation_date_dialog.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateLastDonationDateTile extends StatelessWidget {
  const UpdateLastDonationDateTile({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const ListTile(
        title: Text('No user logged in'),
      );
    }

    return StreamBuilder<UserModel>(
      stream: getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            title: Text('Loading...'),
          );
        }

        if (snapshot.hasError) {
          return ListTile(
            title: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData) {
          return const ListTile(
            title: Text('User data not found'),
          );
        }

        final userData = snapshot.data!;
        final lastDonationDate = userData.lastDonationDate;

        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'updateDonationDate'.tr(context),
            style: TextStyles.bold16,
          ),
          trailing: const Icon(Icons.edit, size: 18),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => UpdateDonationDateDialog(
                userId: currentUser.uid,
                lastDonationDate: lastDonationDate,
              ),
            );
          },
        );
      },
    );
  }
}


import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/core/widget/coustom_circular_progress_indicator.dart';
import 'package:blood_bank/core/widget/coustom_dialog.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/info_column.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BigInfoCard extends StatefulWidget {
  final String savedLives;
  final String bloodGroup;
  final String nextDonationDate;

  const BigInfoCard({
    super.key,
    required this.savedLives,
    required this.bloodGroup,
    required this.nextDonationDate,
  });

  @override
  State<BigInfoCard> createState() => _BigInfoCardState();
}

class _BigInfoCardState extends State<BigInfoCard> {
  bool _promptOpen = false; // prevent multiple dialogs in stream rebuilds

  @override
  Widget build(BuildContext context) {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid == null) {
      return const Center(child: Text('No user is logged in'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('donerRequest')
          .where('uId', isEqualTo: currentUserUid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CustomCircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return CustomDialog(
            title: 'error_occurred'.tr(context),
            content: 'error_occurred: ${snapshot.error}'.tr(context),
          );
        }

        final requests = snapshot.data?.docs ?? [];
        String formattedNextDonationDate = 'next_donation_date'.tr(context);
        bool isTodayDonationDay = false;

        if (requests.isNotEmpty) {
          final request = requests.first;
          final data = request.data() as Map<String, dynamic>?;

          if (data != null && data['nextDonationDate'] is Timestamp) {
            final ts = data['nextDonationDate'] as Timestamp;
            final nextDonationDateTime = ts.toDate();

            formattedNextDonationDate =
                DateFormat('yyyy-MM-dd').format(nextDonationDateTime);

            // Today check
            final now = DateTime.now();
            if (nextDonationDateTime.year == now.year &&
                nextDonationDateTime.month == now.month &&
                nextDonationDateTime.day == now.day) {
              isTodayDonationDay = true;
            }

            // Passed-by-at-least-one-day check using date-only
            final today = DateTime(now.year, now.month, now.day);
            final scheduled = DateTime(
              nextDonationDateTime.year,
              nextDonationDateTime.month,
              nextDonationDateTime.day,
            );
            final daysDiff = today.difference(scheduled).inDays;

            if (daysDiff >= 1 && !_promptOpen) {
              _promptOpen = true; // lock to avoid multiple prompts
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (!mounted) return;
                await _promptUserDonationStatus(context, request);
                if (mounted) {
                  _promptOpen = false; // unlock after flow completes
                }
              });
            }
          } else {
            formattedNextDonationDate =
                'no_next_donation_scheduled'.tr(context);
          }
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoColumn(
                  title: widget.savedLives, image: Assets.imagesLifesaved),
              InfoColumn(title: widget.bloodGroup, image: Assets.imagesBlood),
              InfoColumn(
                title: isTodayDonationDay
                    ? 'Today is your donation day'.tr(context)
                    : formattedNextDonationDate,
                image: Assets.imagesNextdonation,
                isTodayDonationDay: isTodayDonationDay,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _promptUserDonationStatus(
      BuildContext context,
      DocumentSnapshot request,
      ) async {
    // First prompt: did you donate?
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Donation Day Passed'),
        content: const Text('Did you donate on your scheduled day?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop('no'),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop('yes'),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (result == 'yes') {
      // افتح الدايلوج التاني بعد ما الأول يتقفل فعليًا
      final hospitalName = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          final controller = TextEditingController();
          return AlertDialog(
            title: const Text('Enter Hospital Name'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'Hospital Name'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(dialogContext).pop(controller.text.trim()),
                child: const Text('Save'),
              ),
            ],
          );
        },
      );

      if (!mounted) return;

      if (hospitalName != null && hospitalName.isNotEmpty) {
        try {
          await FirebaseFirestore.instance
              .collection('successfulDonations')
              .add({
            'uId': FirebaseAuth.instance.currentUser?.uid,
            'donationDate': Timestamp.now(),
            'hospitalName': hospitalName,
          });

          await FirebaseFirestore.instance
              .collection('donerRequest')
              .doc(request.id)
              .delete();

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Donation recorded and request deleted'),
            ),
          );
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    } else if (result == 'no') {
      Future.microtask(() async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );

        if (!mounted) return;

        if (pickedDate != null) {
          try {
            await FirebaseFirestore.instance
                .collection('donerRequest')
                .doc(request.id)
                .update({
              'nextDonationDate': Timestamp.fromDate(pickedDate),
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Next donation date updated')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          }
        }
      });
    }
  }
}


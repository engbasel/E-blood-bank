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
  bool _promptOpen = false;

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

            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final scheduled = DateTime(nextDonationDateTime.year,
                nextDonationDateTime.month, nextDonationDateTime.day);

            if (scheduled.isAtSameMomentAs(today)) {
              isTodayDonationDay = true;
            }

            if (today.isAfter(scheduled) && !_promptOpen) {
              _promptOpen = true;
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await _handleDonationFlow(context, request);
                if (mounted) setState(() => _promptOpen = false);
              });
            }
          }
        } else {
          formattedNextDonationDate = 'no_next_donation_scheduled'.tr(context);
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

  Future<void> _handleDonationFlow(
      BuildContext context, DocumentSnapshot request) async {
    final result = await _showSimpleDialog(context, 'Donation Day Passed',
        'Did you donate on your scheduled day?');

    if (!mounted || result == null) return;

    if (result == 'yes') {
      final hospitalName = await _showTextFieldDialog(context);
      if (hospitalName != null && hospitalName.isNotEmpty) {
        await _recordSuccessfulDonation(context, request, hospitalName);
      }
    } else {
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
      if (pickedDate != null) {
        await _updateNextDonationDate(context, request.id, pickedDate);
      }
    }
  }

  Future<String?> _showSimpleDialog(
      BuildContext context, String title, String content) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, 'no'),
              child: const Text('No')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, 'yes'),
              child: const Text('Yes')),
        ],
      ),
    );
  }

  Future<String?> _showTextFieldDialog(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter Hospital Name'),
        content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Hospital Name')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: const Text('Save')),
        ],
      ),
    );
  }

  Future<void> _recordSuccessfulDonation(
      BuildContext context, DocumentSnapshot request, String hospital) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final batch = FirebaseFirestore.instance.batch();
    final now = DateTime.now();

    batch.set(
        FirebaseFirestore.instance.collection('successfulDonations').doc(), {
      'uId': uid,
      'donationDate': Timestamp.fromDate(now),
      'hospitalName': hospital,
    });

    batch.update(FirebaseFirestore.instance.collection('users').doc(uid), {
      'lastDonationDate': DateFormat('yyyy-MM-dd').format(now),
    });

    batch.delete(request.reference);

    try {
      await batch.commit();
      if (context.mounted)
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Donation recorded successfully!')));
    } catch (e) {
      if (context.mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _updateNextDonationDate(
      BuildContext context, String docId, DateTime newDate) async {
    try {
      await FirebaseFirestore.instance
          .collection('donerRequest')
          .doc(docId)
          .update({
        'nextDonationDate': Timestamp.fromDate(newDate),
      });
      if (context.mounted)
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Rescheduled successfully')));
    } catch (e) {
      if (context.mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}

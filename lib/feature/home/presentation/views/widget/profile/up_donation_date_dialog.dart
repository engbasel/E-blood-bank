import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/widget/custom_request_text_field.dart';
import 'package:blood_bank/core/widget/custom_snack_bar.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateDonationDateDialog extends StatefulWidget {
  final String userId;
  final DateTime? lastDonationDate;

  const UpdateDonationDateDialog({
    super.key,
    required this.userId,
    this.lastDonationDate,
  });

  @override
  State<UpdateDonationDateDialog> createState() =>
      _UpdateDonationDateDialogState();
}

class _UpdateDonationDateDialogState extends State<UpdateDonationDateDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController lastDonationDateController =
      TextEditingController();
  final TextEditingController newDonationDateController =
      TextEditingController();
  DateTime? newDonationDate;

  @override
  void initState() {
    super.initState();
    if (widget.lastDonationDate != null) {
      lastDonationDateController.text =
          DateFormat('yyyy-MM-dd').format(widget.lastDonationDate!);
    }
  }

  @override
  void dispose() {
    lastDonationDateController.dispose();
    newDonationDateController.dispose();
    super.dispose();
  }

  DateTime _stripTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'updateDonationDate'.tr(context),
        style: TextStyles.bold16,
        textAlign: TextAlign.center,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomRequestTextField(
              controller: lastDonationDateController,
              hintText: "last_request_date".tr(context),
              readOnly: true,
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            const SizedBox(height: 12),
            CustomRequestTextField(
              controller: newDonationDateController,
              hintText: 'next_donation_date'.tr(context),
              readOnly: true,
              suffixIcon: const Icon(Icons.calendar_today),
              onTap: _pickNewDonationDate,
              validator: (_) {
                if (newDonationDate == null) {
                  return 'pleaseSelectNewDonationDate'.tr(context);
                }
                if (widget.lastDonationDate != null) {
                  if (!newDonationDate!
                      .isAfter(_stripTime(widget.lastDonationDate!))) {
                    return 'newDonationDateAfterLastDonationError'.tr(context);
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('cancel'.tr(context), style: TextStyles.bold13),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text('submit'.tr(context), style: TextStyles.bold13),
        ),
      ],
    );
  }

  void _pickNewDonationDate() async {
    final DateTime now = _stripTime(DateTime.now());

    DateTime minAllowedDate;
    if (widget.lastDonationDate != null) {
      minAllowedDate =
          _stripTime(widget.lastDonationDate!).add(const Duration(days: 56));
    } else {
      minAllowedDate = now;
    }

    final DateTime initialDate =
        minAllowedDate.isBefore(now) ? now : minAllowedDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        newDonationDate = _stripTime(picked);
        newDonationDateController.text =
            DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState?.validate() != true) return;

    if (widget.lastDonationDate != null && newDonationDate != null) {
      final DateTime lastDateOnly = _stripTime(widget.lastDonationDate!);
      final DateTime nextDateOnly = _stripTime(newDonationDate!);

      final int differenceInDays = nextDateOnly.difference(lastDateOnly).inDays;

      if (differenceInDays < 56) {
        failureTopSnackBar(
          context,
          'There must be at least 56 days between donations'.tr(context),
        );
        return;
      }
    }

    try {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(widget.userId);

      await userDoc.update({
        'lastDonationDate': Timestamp.fromDate(newDonationDate!),
      });

      if (mounted) Navigator.pop(context);
      {
        successTopSnackBar(
          context,
          'Last donation date updated successfully'.tr(context),
        );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.error(
          textStyle: const TextStyle(color: Colors.white),
          backgroundColor: AppColors.backgroundColor,
          message: 'An error occurred: $e',
        );
      }
    }
  }
}

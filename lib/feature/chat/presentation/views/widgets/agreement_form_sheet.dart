import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/widget/custom_button.dart';
import 'package:blood_bank/core/widget/custom_request_text_field.dart';
import 'package:blood_bank/core/widget/date_picker_field.dart';
import 'package:blood_bank/core/widget/governorate_drop_down.dart';
import 'package:blood_bank/core/widget/hospital_drop_down.dart';
import 'package:blood_bank/core/constants/hospitals_by_governorate.dart';

class AgreementFormSheet extends StatefulWidget {
  final String donorName;
  final String neederName;
  final String? donorImage;
  final String? neederImage;

  const AgreementFormSheet({
    super.key,
    required this.donorName,
    required this.neederName,
    this.donorImage,
    this.neederImage,
  });

  @override
  State<AgreementFormSheet> createState() => _AgreementFormSheetState();
}

class _AgreementFormSheetState extends State<AgreementFormSheet> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController hospitalNameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController donationDateController = TextEditingController();

  String? selectedGovernorate;
  String? selectedHospital;

  @override
  void dispose() {
    hospitalNameController.dispose();
    notesController.dispose();
    donationDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildUserCircle(widget.neederName, widget.neederImage,
                      "need".tr(context)),
                  Icon(Icons.handshake_rounded,
                      color: AppColors.primaryColor, size: 35),
                  _buildUserCircle(
                      widget.donorName, widget.donorImage, "donor".tr(context)),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                "Agreement Details".tr(context),
                style: TextStyles.bold16
                    .copyWith(color: AppColors.primaryColor, fontSize: 18),
              ),
              const SizedBox(height: 20),
              DatePickerField(
                isNextDonationDate: true,
                hintStyle: TextStyle(color: AppColors.primaryColor),
                controller: donationDateController,
                context: context,
                label: 'next_donation_date'.tr(context),
                selectedDate: null,
                onDateSelected: (date) {
                  setState(() {
                    donationDateController.text =
                        DateFormat('yyyy-MM-dd').format(date);
                  });
                },
              ),
              const SizedBox(height: 12),
              GovernorateDropdown(
                selectedKey: selectedGovernorate,
                onChanged: (value) {
                  setState(() {
                    selectedGovernorate = value;
                    selectedHospital = null;
                    hospitalNameController.clear();
                  });
                },
              ),
              const SizedBox(height: 12),
              HospitalDropdown(
                hospitals: selectedGovernorate == null
                    ? []
                    : hospitalsByGovernorate[selectedGovernorate!] ?? [],
                selectedHospital: selectedHospital,
                onChanged: (value) {
                  setState(() {
                    selectedHospital = value;
                    hospitalNameController.text = value ?? '';
                  });
                },
              ),
              const SizedBox(height: 12),
              CustomRequestTextField(
                controller: notesController,
                hintText: "additional_notes".tr(context),
                maxLines: 2,
                hintStyle: TextStyle(color: AppColors.primaryColor),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Confirm'.tr(context),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {}
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCircle(String name, String? imageUrl, String role) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: AppColors.primaryColor.withValues(alpha: 0.2), width: 2),
          ),
          child: CircleAvatar(
            radius: 35,
            backgroundColor: Colors.grey[100],
            backgroundImage:
                imageUrl != null ? CachedNetworkImageProvider(imageUrl) : null,
            child: imageUrl == null
                ? Icon(Icons.person, color: AppColors.primaryColor, size: 35)
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Text(name, style: TextStyles.bold16.copyWith(fontSize: 14)),
        Text(role,
            style: TextStyles.regular16
                .copyWith(color: Colors.grey, fontSize: 11)),
      ],
    );
  }
}

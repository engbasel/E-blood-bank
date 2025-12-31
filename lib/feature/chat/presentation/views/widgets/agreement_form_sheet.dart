import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
import 'package:blood_bank/feature/auth/data/models/user_model.dart';
import 'package:blood_bank/feature/chat/data/models/agreement_model.dart';
import 'package:blood_bank/feature/chat/data/repo/agreement_repo_imple.dart';
import 'package:blood_bank/feature/chat/presentation/manager/agreement_create_cubit/agreement_create_cubit.dart';
import 'package:blood_bank/feature/chat/presentation/manager/agreement_create_cubit/agreement_create_state.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final UserModel donor;
  final UserModel needer;

  const AgreementFormSheet({
    super.key,
    required this.donor,
    required this.needer,
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
    return BlocProvider(
      create: (context) => AgreementCreateCubit(AgreementRepoImpl()),
      child: BlocConsumer<AgreementCreateCubit, AgreementCreateState>(
        listener: (context, state) {
          if (state is AgreementCreateSuccess) {
            successTopSnackBar(
              context,
              "agreement_sent_successfully".tr(context),
            );
            Navigator.pop(context);
          } else if (state is AgreementCreateError) {
            failureTopSnackBar(
              context,
              "agreement_send_failed".tr(context),
            );
          }
        },
        builder: (context, state) {
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
                        _buildUserCircle(widget.needer.name!,
                            widget.needer.photoUrl, "need".tr(context)),
                        Icon(Icons.handshake_rounded,
                            color: AppColors.primaryColor, size: 35),
                        _buildUserCircle(widget.donor.name!,
                            widget.donor.photoUrl, "donor".tr(context)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Agreement Details".tr(context),
                      style: TextStyles.bold16.copyWith(
                          color: AppColors.primaryColor, fontSize: 18),
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
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<AgreementCreateCubit>(context)
                              .createNewAgreement(
                            context: context,
                            donorName: widget.donor.name!,
                            agreement: AgreementModel(
                              id: '',
                              donorId: widget.donor.uId,
                              neederId: widget.needer.uId,
                              status: 'pending',
                              donorDecision: 'none',
                              neederDecision: 'confirmed',
                              timestamp: DateTime.now(),
                              governorate: selectedGovernorate!,
                              hospitalName: selectedHospital!,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          );
        },
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

import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
import 'package:blood_bank/core/helper_function/validators_textform.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/widget/custom_button.dart';
import 'package:blood_bank/core/widget/custom_request_text_field.dart';
import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_bloc.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_event.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DonorRequestForm extends StatefulWidget {
  const DonorRequestForm({super.key});

  @override
  DonorRequestFormState createState() => DonorRequestFormState();
}

class DonorRequestFormState extends State<DonorRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final User? _user = FirebaseAuth.instance.currentUser;

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController medicalConditionsController =
      TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController unitsController = TextEditingController();
  final TextEditingController idCardController = TextEditingController();
  final TextEditingController hospitalNameController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController lastDonationDateController =
      TextEditingController();
  final TextEditingController nextDonationDateController =
      TextEditingController();
  final TextEditingController donationTypeController = TextEditingController();

  DateTime? lastDonationDate;
  DateTime? nextDonationDate;

  Future<void> _pickLastDonationDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        lastDonationDate = picked;
        lastDonationDateController.text =
            DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _pickNextDonationDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        nextDonationDate = picked;
        nextDonationDateController.text =
            DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitRequest() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final value = lastDonationDateController.text;
    if (value.isNotEmpty) {
      final selected = DateTime.parse(value);
      final diff = DateTime.now().difference(selected).inDays;
      if (diff < 90) {
        failureTopSnackBar(
            context, 'minimum_donation_interval_error'.tr(context));
        return;
      }
    }

    _formKey.currentState!.save();

    if (_user == null) {
      failureTopSnackBar(context, 'user_not'.tr(context));
      return;
    }

    final request = DonorRequestEntity(
      uId: _user.uid,
      name: nameController.text,
      age: num.parse(ageController.text),
      bloodType: bloodTypeController.text,
      donationType: donationTypeController.text,
      gender: genderController.text,
      idCard: num.parse(idCardController.text),
      lastDonationDate: lastDonationDate,
      nextDonationDate: nextDonationDate,
      medicalConditions: medicalConditionsController.text,
      units: num.parse(unitsController.text),
      contact: num.parse(contactController.text),
      address: addressController.text,
      notes: notesController.text,
      hospitalName: hospitalNameController.text,
      distance: num.parse(distanceController.text),
      photoUrl: _user.photoURL ?? '',
    );

    context.read<DonorRequestsBloc>().add(
          SubmitDonorRequestEvent(request: request),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(height: 16),
              CustomRequestTextField(
                controller: nameController,
                hintText: 'Name'.tr(context),
                hintStyle: TextStyle(color: AppColors.primaryColor),
                validator: (value) => Validators.validateName(value, context),
              ),
              const SizedBox(height: 16),
              CustomRequestTextField(
                controller: ageController,
                hintText: 'Age'.tr(context),
                textInputType: TextInputType.number,
                validator: (value) => Validators.validateAge(value, context),
              ),
              const SizedBox(height: 16),
              CustomRequestTextField(
                controller: bloodTypeController,
                hintText: 'Blood Type'.tr(context),
                validator: (value) => Validators.validateName(value, context),
              ),
              const SizedBox(height: 16),
              CustomRequestTextField(
                controller: donationTypeController,
                hintText: 'Donation Type'.tr(context),
                validator: (value) => Validators.validateName(value, context),
              ),
              const SizedBox(height: 16),
              CustomRequestTextField(
                controller: idCardController,
                hintText: 'ID Card'.tr(context),
                textInputType: TextInputType.number,
                validator: (value) => Validators.validateIdCard(value, context),
              ),
              const SizedBox(height: 16),

              // LAST DONATION DATE
              CustomRequestTextField(
                controller: lastDonationDateController,
                hintText: 'Last Donation Date'.tr(context),
                readOnly: true,
                onTap: _pickLastDonationDate,
                validator: (_) {
                  final value = lastDonationDateController.text;
                  if (value.isEmpty) {
                    return 'lastDonationDateRequired'.tr(context);
                  }

                  try {
                    final selected = DateTime.parse(value);
                    final today = DateTime(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day);

                    if (selected.isAfter(today)) {
                      return 'lastDonationDateFutureError'.tr(context);
                    }

                    final diff = today.difference(selected).inDays;
                    if (diff < 90) {
                      return 'minimum_donation_interval_error'.tr(context);
                    }
                  } catch (_) {
                    return 'invalid date format';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // NEXT DONATION DATE
              CustomRequestTextField(
                controller: nextDonationDateController,
                hintText: 'Next Donation Date'.tr(context),
                readOnly: true,
                onTap: _pickNextDonationDate,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'nextDonationDateRequired'.tr(context);
                  }

                  try {
                    final date = DateTime.parse(value);
                    final selected = DateTime(date.year, date.month, date.day);
                    final today = DateTime(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day);

                    if (selected.isBefore(today)) {
                      return 'next_donation_date_past_error'.tr(context);
                    }
                  } catch (_) {
                    return 'invalid date format';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              CustomRequestTextField(
                controller: medicalConditionsController,
                hintText: 'Medical Conditions'.tr(context),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              CustomRequestTextField(
                controller: unitsController,
                hintText: 'Units'.tr(context),
                textInputType: TextInputType.number,
                validator: (value) =>
                    Validators.validateUnitsRequired(value, context),
              ),
              const SizedBox(height: 16),
              CustomRequestTextField(
                controller: contactController,
                hintText: 'Contact Number'.tr(context),
                textInputType: TextInputType.phone,
                validator: (value) =>
                    Validators.validateContactNumber(value, context),
              ),
              const SizedBox(height: 16),
              CustomRequestTextField(
                controller: addressController,
                hintText: 'Address'.tr(context),
                validator: (value) => Validators.validateName(value, context),
              ),
              const SizedBox(height: 16),
              CustomRequestTextField(
                controller: notesController,
                hintText: 'Notes'.tr(context),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              CustomRequestTextField(
                controller: hospitalNameController,
                hintText: 'Hospital Name'.tr(context),
                validator: (value) =>
                    Validators.validateHospitalName(value, context),
              ),
              const SizedBox(height: 16),
              CustomRequestTextField(
                controller: distanceController,
                hintText: 'Distance'.tr(context),
                textInputType: TextInputType.number,
                validator: (value) =>
                    Validators.validateDistance(value, context),
              ),
              const SizedBox(height: 16),
              CustomRequestTextField(
                controller: genderController,
                hintText: 'Gender'.tr(context),
                validator: (value) => Validators.validateName(value, context),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Submit Request'.tr(context),
                onPressed: _submitRequest,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

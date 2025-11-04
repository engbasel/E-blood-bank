import 'dart:developer';
import 'package:blood_bank/core/helper_function/add_doner_functions_class.dart';
import 'package:blood_bank/core/helper_function/validators_textform.dart';
import 'package:blood_bank/core/services/get_it_service.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/widget/blood_type_drop_down.dart';
import 'package:blood_bank/core/widget/custom_button.dart';
import 'package:blood_bank/core/widget/custom_request_text_field.dart';
import 'package:blood_bank/core/widget/date_picker_field.dart';
import 'package:blood_bank/core/widget/donation_type_drop_down.dart';
import 'package:blood_bank/core/widget/gender_drop_down.dart';
import 'package:blood_bank/core/widget/governorate_drop_down.dart';
import 'package:blood_bank/feature/home/data/datasources/doner_remote_data_source.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_bloc.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_event.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DonorRequest extends StatefulWidget {
  const DonorRequest({super.key});

  @override
  DonorRequestState createState() => DonorRequestState();
}

class DonorRequestState extends State<DonorRequest> {
  final _formKey = GlobalKey<FormState>();
  final User? _user = FirebaseAuth.instance.currentUser;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController medicalConditionsController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController unitsController = TextEditingController();
  final TextEditingController idCardController = TextEditingController();
  final TextEditingController hospitalNameController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController lastDonationDateController = TextEditingController();
  final TextEditingController nextDonationDateController = TextEditingController();
  final TextEditingController donationTypeController = TextEditingController();

  late AddDonorFunctions _addDonorFunction;

  @override
  void initState() {
    super.initState();
    _addDonorFunction = AddDonorFunctions(
      context: context,
      user: _user,
      formKey: _formKey,
      nameController: nameController,
      ageController: ageController,
      lastDonationDateController: lastDonationDateController,
      idCardController: idCardController,
      medicalConditionsController: medicalConditionsController,
      contactController: contactController,
      unitsController: unitsController,
      notesController: notesController,
      addressController: addressController,
      hospitalNameController: hospitalNameController,
      distanceController: distanceController,
      bloodTypeController: bloodTypeController,
      genderController: genderController,
      nextDonationDateController: nextDonationDateController,
      donationTypeController: donationTypeController,
      donorRemoteDataSource: getIt<DonorRemoteDataSource>(),


    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            spacing: 12,
            children: [
              CustomRequestTextField(
                hintStyle: TextStyle(color: AppColors.primaryColor),
                controller: nameController,
                hintText: 'Name'.tr(context),
                validator: (value) => Validators.validateName(value, context),
                onSaved: (value) {
                  log('Name: ${nameController.text}');
                },
              ),
              CustomRequestTextField(
                hintStyle: TextStyle(color: AppColors.primaryColor),
                controller: ageController,
                textInputType: TextInputType.number,
                validator: (value) => Validators.validateAge(value, context),
                hintText: 'age'.tr(context),
                onSaved: (value) {
                  log('Age: ${ageController.text}');
                },
              ),
              BloodTypeDropdown(
                selectedBloodType: bloodTypeController.text.isNotEmpty
                    ? bloodTypeController.text
                    : null,
                onChanged: (selectedBloodType) {
                  bloodTypeController.text = selectedBloodType ?? '';
                  log('Blood Type: ${bloodTypeController.text}');
                },
              ),
              DonationTypeDropdown(
                initialType: null,
                onTypeSelected: (selectedType) {
                  donationTypeController.text = selectedType;
                  log('Donation Type: ${donationTypeController.text}');
                },
              ),
              GovernorateDropdown(
                selectedKey: addressController.text.isNotEmpty
                    ? addressController.text
                    : null,
                onChanged: (value) {
                  addressController.text = value ?? '';
                  log('Address: ${addressController.text}');
                },
              ),
              GenderDropdown(
                onGenderSelected: (gender) {
                  genderController.text = gender;
                  log('Gender: ${genderController.text}');
                },
              ),
              CustomRequestTextField(
                hintStyle: TextStyle(color: AppColors.primaryColor),
                controller: idCardController,
                hintText: '302090********* only 14'.tr(context),
                textInputType: TextInputType.number,
                validator: (value) => Validators.validateIdCard(value, context),
                onSaved: (value) {
                  log('ID Card: ${idCardController.text}');
                },
              ),
              DatePickerField(
                controller: lastDonationDateController,
                hintStyle: TextStyle(color: AppColors.primaryColor),
                context: context,
                label: 'last_donation_date'.tr(context),
                selectedDate: null,
                onDateSelected: (date) {
                  lastDonationDateController.text =
                  date.toString().split(' ')[0];
                  log('Last Donation Date: ${lastDonationDateController.text}');
                },
                isNextDonationDate: false,
              ),
              DatePickerField(
                controller: nextDonationDateController,
                hintStyle: TextStyle(color: AppColors.primaryColor),
                context: context,
                label: 'next_donation_date'.tr(context),
                selectedDate: null,
                onDateSelected: (date) {
                  nextDonationDateController.text =
                  date.toString().split(' ')[0];
                  log('Next Donation Date: ${nextDonationDateController.text}');
                },
                isNextDonationDate: true,
              ),
              CustomRequestTextField(
                hintStyle: TextStyle(color: AppColors.primaryColor),
                controller: medicalConditionsController,
                hintText: 'medicalConditions'.tr(context),
                maxLines: 3,
                onSaved: (value) {
                  log('Medical Conditions: ${medicalConditionsController.text}');
                },
              ),
              CustomRequestTextField(
                hintStyle: TextStyle(color: AppColors.primaryColor),
                controller: unitsController,
                hintText: 'UnitsRequired'.tr(context),
                textInputType: TextInputType.number,
                validator: (value) =>
                    Validators.validateUnitsRequired(value, context),
                onSaved: (value) {
                  log('Units Required: ${unitsController.text}');
                },
              ),
              CustomRequestTextField(
                hintStyle: TextStyle(color: AppColors.primaryColor),
                controller: contactController,
                hintText: 'contactNumber'.tr(context),
                textInputType: TextInputType.phone,
                validator: (value) =>
                    Validators.validateContactNumber(value, context),
                onSaved: (value) {
                  log('Contact Number: ${contactController.text}');
                },
              ),
              CustomRequestTextField(
                hintStyle: TextStyle(color: AppColors.primaryColor),
                controller: notesController,
                hintText: 'Notes'.tr(context),
                maxLines: 3,
                onSaved: (value) {
                  log('Notes: ${notesController.text}');
                },
              ),
              CustomRequestTextField(
                hintStyle: TextStyle(color: AppColors.primaryColor),
                controller: hospitalNameController,
                hintText: 'hospitalName'.tr(context),
                validator: (value) =>
                    Validators.validateHospitalName(value, context),
                onSaved: (value) {
                  log('Hospital Name: ${hospitalNameController.text}');
                },
              ),

              CustomRequestTextField(
                hintStyle: TextStyle(color: AppColors.primaryColor),
                controller: distanceController,
                textInputType: TextInputType.number,
                hintText: 'Distance'.tr(context),
                validator: (value) =>
                    Validators.validateDistance(value, context),
                onSaved: (value) {
                  log('Distance: ${distanceController.text}');
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Submit Request'.tr(context),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final entity = await _addDonorFunction.toEntityWithCheck();
                    if (entity != null) {
                      context.read<AddDonorRequestBloc>().add(
                        SubmitDonorRequestEvent(request: entity),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}


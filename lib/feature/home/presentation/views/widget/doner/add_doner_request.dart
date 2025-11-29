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
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_state.dart'; // تأكد من استيراد حالة الـ Bloc
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
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    notesController.dispose();
    medicalConditionsController.dispose();
    ageController.dispose();
    contactController.dispose();
    unitsController.dispose();
    idCardController.dispose();
    hospitalNameController.dispose();
    distanceController.dispose();
    bloodTypeController.dispose();
    genderController.dispose();
    lastDonationDateController.dispose();
    nextDonationDateController.dispose();
    donationTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DonorRequestsBloc, DonorRequestsState>(
      listener: (context, state) {
        if (state is DonorRequestsSuccess) {
          _clearAllFields();
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {});

        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: [
                CustomRequestTextField(
                  hintStyle: TextStyle(color: AppColors.primaryColor),
                  controller: nameController,
                  hintText: 'Name'.tr(context),
                  validator: (value) => Validators.validateName(value, context),
                ),
                const SizedBox(height: 12),
                CustomRequestTextField(
                  hintStyle: TextStyle(color: AppColors.primaryColor),
                  controller: ageController,
                  textInputType: TextInputType.number,
                  validator: (value) => Validators.validateAge(value, context),
                  hintText: 'age'.tr(context),
                ),
                const SizedBox(height: 12),
                BloodTypeDropdown(
                  selectedBloodType: bloodTypeController.text.isNotEmpty
                      ? bloodTypeController.text
                      : null,
                  onChanged: (selectedBloodType) {
                    bloodTypeController.text = selectedBloodType ?? '';
                  },
                ),
                const SizedBox(height: 12),
                DonationTypeDropdown(
                  initialType: null,
                  onTypeSelected: (selectedType) {
                    donationTypeController.text = selectedType;
                  },
                ),
                const SizedBox(height: 12),
                GovernorateDropdown(
                  selectedKey: addressController.text.isNotEmpty
                      ? addressController.text
                      : null,
                  onChanged: (value) {
                    addressController.text = value ?? '';
                  },
                ),
                const SizedBox(height: 12),
                GenderDropdown(
                  onGenderSelected: (gender) {
                    genderController.text = gender;
                  },
                ),
                const SizedBox(height: 12),
                CustomRequestTextField(
                  hintStyle: TextStyle(color: AppColors.primaryColor),
                  controller: idCardController,
                  hintText: '302090********* only 14'.tr(context),
                  textInputType: TextInputType.number,
                  validator: (value) =>
                      Validators.validateIdCard(value, context),
                  maxLength: 14,
                ),
                const SizedBox(height: 12),
                DatePickerField(
                  controller: lastDonationDateController,
                  hintStyle: TextStyle(color: AppColors.primaryColor),
                  context: context,
                  label: 'last_donation_date'.tr(context),
                  selectedDate: null,
                  onDateSelected: (date) {
                    lastDonationDateController.text =
                        date.toString().split(' ')[0];
                  },
                  isNextDonationDate: false,
                ),
                const SizedBox(height: 12),
                DatePickerField(
                  controller: nextDonationDateController,
                  hintStyle: TextStyle(color: AppColors.primaryColor),
                  context: context,
                  label: 'next_donation_date'.tr(context),
                  selectedDate: null,
                  onDateSelected: (date) {
                    nextDonationDateController.text =
                        date.toString().split(' ')[0];
                  },
                  isNextDonationDate: true,
                ),
                const SizedBox(height: 12),
                CustomRequestTextField(
                  hintStyle: TextStyle(color: AppColors.primaryColor),
                  controller: medicalConditionsController,
                  hintText: 'medicalConditions'.tr(context),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                CustomRequestTextField(
                  hintStyle: TextStyle(color: AppColors.primaryColor),
                  controller: unitsController,
                  hintText: 'UnitsRequired'.tr(context),
                  textInputType: TextInputType.number,
                  validator: (value) =>
                      Validators.validateUnitsRequired(value, context),
                ),
                const SizedBox(height: 12),
                CustomRequestTextField(
                  hintStyle: TextStyle(color: AppColors.primaryColor),
                  controller: contactController,
                  hintText: 'contactNumber'.tr(context),
                  textInputType: TextInputType.phone,
                  validator: (value) =>
                      Validators.validateContactNumber(value, context),
                  maxLength: 11,
                ),
                const SizedBox(height: 12),
                CustomRequestTextField(
                  hintStyle: TextStyle(color: AppColors.primaryColor),
                  controller: notesController,
                  hintText: 'Notes'.tr(context),
                  maxLines: 3,
                  onSaved: (value) {},
                ),
                const SizedBox(height: 12),
                CustomRequestTextField(
                  hintStyle: TextStyle(color: AppColors.primaryColor),
                  controller: hospitalNameController,
                  hintText: 'hospitalName'.tr(context),
                  validator: (value) =>
                      Validators.validateHospitalName(value, context),
                ),
                const SizedBox(height: 12),
                CustomRequestTextField(
                  hintStyle: TextStyle(color: AppColors.primaryColor),
                  controller: distanceController,
                  textInputType: TextInputType.number,
                  hintText: 'Distance'.tr(context),
                  validator: (value) =>
                      Validators.validateDistance(value, context),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Submit Request'.tr(context),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final entity =
                          await _addDonorFunction.toEntityWithCheck();
                      if (entity != null) {
                        context.read<DonorRequestsBloc>().add(
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
      ),
    );
  }

  void _clearAllFields() {
    nameController.clear();
    ageController.clear();
    idCardController.clear();
    unitsController.clear();
    contactController.clear();
    hospitalNameController.clear();
    distanceController.clear();
    notesController.clear();
    medicalConditionsController.clear();
    bloodTypeController.clear();
    genderController.clear();
    donationTypeController.clear();
    addressController.clear();
    lastDonationDateController.clear();
    nextDonationDateController.clear();
  }
}

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

class DonorRequestForm extends StatefulWidget {
  const DonorRequestForm({super.key});

  @override
  DonorRequestFormState createState() => DonorRequestFormState();
}

class DonorRequestFormState extends State<DonorRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final User? _user = FirebaseAuth.instance.currentUser;

  // Form Controllers
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

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_user == null) {
        // Handle unauthenticated user
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
        lastDonationDate: lastDonationDateController.text.isNotEmpty
            ? DateTime.parse(lastDonationDateController.text)
            : null,
        nextDonationDate: nextDonationDateController.text.isNotEmpty
            ? DateTime.parse(nextDonationDateController.text)
            : null,
        medicalConditions: medicalConditionsController.text,
        units: num.parse(unitsController.text),
        contact: num.parse(contactController.text),
        address: addressController.text,
        notes: notesController.text,
        hospitalName: hospitalNameController.text,
        distance: num.parse(distanceController.text),
        photoUrl: _user.photoURL ?? '',
      );

      context.read<AddDonorRequestBloc>().add(SubmitDonorRequestEvent(request: request));
    }
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
              CustomRequestTextField(
                controller: lastDonationDateController,
                hintText: 'Last Donation Date'.tr(context),
              ),
              const SizedBox(height: 16),
              CustomRequestTextField(
                controller: nextDonationDateController,
                hintText: 'Next Donation Date'.tr(context),
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

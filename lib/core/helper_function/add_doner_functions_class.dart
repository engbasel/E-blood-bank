import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
import 'package:blood_bank/feature/home/data/datasources/doner_remote_data_source.dart';
import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddDonorFunctions {
  final BuildContext context;
  final User? user;
  final GlobalKey<FormState> formKey;

  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController lastDonationDateController;
  final TextEditingController idCardController;
  final TextEditingController medicalConditionsController;
  final TextEditingController contactController;
  final TextEditingController unitsController;
  final TextEditingController notesController;
  final TextEditingController addressController;
  final TextEditingController hospitalNameController;
  final TextEditingController distanceController;
  final TextEditingController bloodTypeController;
  final TextEditingController genderController;
  final TextEditingController nextDonationDateController;
  final TextEditingController donationTypeController;

  final DonorRemoteDataSource donorRemoteDataSource;

  AddDonorFunctions({
    required this.context,
    required this.user,
    required this.formKey,
    required this.nameController,
    required this.ageController,
    required this.lastDonationDateController,
    required this.idCardController,
    required this.medicalConditionsController,
    required this.contactController,
    required this.unitsController,
    required this.notesController,
    required this.addressController,
    required this.hospitalNameController,
    required this.distanceController,
    required this.bloodTypeController,
    required this.genderController,
    required this.nextDonationDateController,
    required this.donationTypeController,
    required this.donorRemoteDataSource,
  });

  Future<DonorRequestEntity?> toEntityWithCheck() async {
    final userId = user?.uid ?? '';
    final hasRequest = await donorRemoteDataSource.hasActiveRequest(userId);

    if (hasRequest) {
      failureTopSnackBar(context, 'You already have an active request');
      return null;
    }

    return DonorRequestEntity(
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
      uId: userId,
      photoUrl: user?.photoURL,
      lastRequestDate: DateTime.now(),
    );
  }
}


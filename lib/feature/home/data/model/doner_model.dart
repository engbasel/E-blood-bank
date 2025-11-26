import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonorModel {
  final String name;
  final num age;
  final String bloodType;
  final String donationType;
  final num idCard;
  final DateTime? lastDonationDate;
  final DateTime? nextDonationDate;
  final DateTime? lastRequestDate;
  final String medicalConditions;
  final num contact;
  final String address;
  final String notes;
  final num units;
  final String gender;
  final String uId;
  final String hospitalName;
  final num distance;
  final String photoUrl;
  DonorModel({
    required this.name,
    required this.age,
    required this.uId,
    required this.bloodType,
    required this.donationType,
    required this.idCard,
    this.lastDonationDate,
    this.nextDonationDate,
    required this.medicalConditions,
    required this.contact,
    required this.address,
    required this.notes,
    required this.units,
    required this.gender,
    required this.hospitalName,
    required this.distance,
    required this.photoUrl,
    this.lastRequestDate,
  });
  factory DonorModel.fromJson(Map<String, dynamic> json) {
    return DonorModel(
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      bloodType: json['bloodType'] ?? '',
      donationType: json['donationType'] ?? '',
      idCard: json['idCard'] ?? 0,
      lastDonationDate: (json['lastDonationDate'] != null)
          ? (json['lastDonationDate'] as Timestamp).toDate()
          : null,
      nextDonationDate: (json['nextDonationDate'] != null)
          ? (json['nextDonationDate'] as Timestamp).toDate()
          : null,
      lastRequestDate: (json['lastRequestDate'] != null)
          ? (json['lastRequestDate'] as Timestamp).toDate()
          : null,
      medicalConditions: json['medicalConditions'] ?? '',
      contact: json['contact'] ?? 0,
      address: json['address'] ?? '',
      notes: json['notes'] ?? '',
      units: json['units'] ?? 0,
      gender: json['gender'] ?? '',
      uId: json['uId'] ?? '',
      hospitalName: json['hospitalName'] ?? '',
      distance: json['distance'] ?? 0,
      photoUrl: json['photoUrl'] ?? '',
    );
  }

  factory DonorModel.fromEntity(DonorRequestEntity addRequestInputEntity) {
    return DonorModel(
      name: addRequestInputEntity.name,
      age: addRequestInputEntity.age,
      bloodType: addRequestInputEntity.bloodType,
      donationType: addRequestInputEntity.donationType,
      idCard: addRequestInputEntity.idCard,
      lastDonationDate: addRequestInputEntity.lastDonationDate,
      nextDonationDate: addRequestInputEntity.nextDonationDate,
      medicalConditions: addRequestInputEntity.medicalConditions,
      contact: addRequestInputEntity.contact,
      address: addRequestInputEntity.address,
      notes: addRequestInputEntity.notes,
      units: addRequestInputEntity.units,
      gender: addRequestInputEntity.gender,
      uId: addRequestInputEntity.uId,
      hospitalName: addRequestInputEntity.hospitalName,
      distance: addRequestInputEntity.distance,
      photoUrl: addRequestInputEntity.photoUrl ?? '',
      lastRequestDate: addRequestInputEntity.lastRequestDate,
    );
  }
  Map<String, Object?> toJson() {
    return {
      'name': name,
      'age': age,
      'bloodType': bloodType,
      'donationType': donationType,
      'idCard': idCard,
      'lastDonationDate': lastDonationDate != null ? Timestamp.fromDate(lastDonationDate!) : null,
      'nextDonationDate': nextDonationDate != null ? Timestamp.fromDate(nextDonationDate!) : null,
      'medicalConditions': medicalConditions,
      'contact': contact,
      'address': address,
      'notes': notes,
      'units': units,
      'gender': gender,
      'uId': uId,
      'hospitalName': hospitalName,
      'distance': distance,
      'lastRequestDate': lastRequestDate != null ? Timestamp.fromDate(lastRequestDate!) : null,
      'photoUrl': photoUrl,
    };
  }

}

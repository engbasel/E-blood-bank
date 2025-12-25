import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final String patientName;
  final String age;
  final String diseaseName;
  final String location;
  final String contactNumber;
  final DateTime? lastDonationDate;

  const UserModel({
    required super.uId,
    required super.name,
    required super.email,
    required super.photoUrl,
    required super.emailVerified,
    required super.userStat,
    required super.userState,
    required super.bloodType,
    required this.patientName,
    required this.age,
    required this.diseaseName,
    required this.location,
    required this.contactNumber,
    this.lastDonationDate,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uId: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      photoUrl: user.photoURL ?? '',
      emailVerified: user.emailVerified,
      userStat: 'allowed',
      userState: 'donor',
      bloodType: '',
      patientName: '',
      age: '',
      diseaseName: '',
      location: '',
      contactNumber: '',
      lastDonationDate: null,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime? lastDate;
    if (json['lastDonationDate'] != null) {
      if (json['lastDonationDate'] is Timestamp) {
        lastDate = (json['lastDonationDate'] as Timestamp).toDate();
      } else if (json['lastDonationDate'] is String) {
        try {
          lastDate = DateTime.parse(json['lastDonationDate']);
        } catch (_) {
          lastDate = null;
        }
      }
    }

    return UserModel(
      uId: json['uId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      emailVerified: json['emailVerified'] ?? false,
      userStat: json['userStat'] ?? 'allowed',
      userState: json['userState'] ?? 'donor',
      bloodType: json['bloodType'] ?? '',
      patientName: json['patientName'] ?? '',
      age: json['age'] ?? '',
      diseaseName: json['diseaseName'] ?? '',
      location: json['location'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      lastDonationDate: lastDate,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'emailVerified': emailVerified,
      'userStat': userStat,
      'userState': userState,
      'bloodType': bloodType,
      'patientName': patientName,
      'age': age,
      'diseaseName': diseaseName,
      'location': location,
      'contactNumber': contactNumber,
      'lastDonationDate': lastDonationDate != null
          ? Timestamp.fromDate(lastDonationDate!)
          : null,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uId: entity.uId,
      name: entity.name ?? '',
      email: entity.email ?? '',
      photoUrl: entity.photoUrl ?? '',
      emailVerified: entity.emailVerified,
      userStat: entity.userStat,
      userState: entity.userState,
      bloodType: entity.bloodType ?? '',
      patientName: '',
      age: '',
      diseaseName: '',
      location: '',
      contactNumber: '',
      lastDonationDate: null, // بدل ' '
    );
  }
}

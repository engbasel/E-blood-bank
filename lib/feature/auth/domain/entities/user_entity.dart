import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uId;
  final String? name;
  final String? email;
  final String? photoURL;
  final bool emailVerified;
  final String userStat;
  final String? bloodType;

  const UserEntity({
    required this.uId,
    this.name,
    this.email,
    this.photoURL,
    this.emailVerified = false,
    this.userStat = 'allowed',
    this.bloodType,
  });

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'name': name,
      'email': email,
      'photoURL': photoURL,
      'emailVerified': emailVerified,
      'userStat': userStat,
      'bloodType': bloodType,
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      uId: map['uId'] ?? '',
      name: map['name'],
      email: map['email'],
      photoURL: map['photoURL'],
      emailVerified: map['emailVerified'] ?? false,
      userStat: map['userStat'] ?? 'allowed',
      bloodType: map['bloodType'],
    );
  }

  UserEntity copyWith({
    String? uId,
    String? name,
    String? email,
    String? photoURL,
    bool? emailVerified,
    String? userStat,
    String? bloodType,
  }) {
    return UserEntity(
      uId: uId ?? this.uId,
      name: name ?? this.name,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      emailVerified: emailVerified ?? this.emailVerified,
      userStat: userStat ?? this.userStat,
      bloodType: bloodType ?? this.bloodType,
    );
  }

  @override
  List<Object?> get props => [
        uId,
        name,
        email,
        photoURL,
        emailVerified,
        userStat,
        bloodType,
      ];
}

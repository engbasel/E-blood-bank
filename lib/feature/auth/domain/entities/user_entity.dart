import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uId;
  final String? name;
  final String? email;
  final String? photoUrl;
  final bool emailVerified;
  final String userStat;
  final String userState;
  final String? bloodType;

  const UserEntity({
    required this.uId,
    this.name,
    this.email,
    this.photoUrl,
    this.emailVerified = false,
    this.userStat = 'allowed',
    this.userState = 'donor',
    this.bloodType,
  });

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
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      uId: map['uId'] ?? '',
      name: map['name'],
      email: map['email'],
      photoUrl: map['photoUrl'],
      emailVerified: map['emailVerified'] ?? false,
      userStat: map['userStat'] ?? 'allowed',
      userState: map['userState'] ?? 'donor',
      bloodType: map['bloodType'],
    );
  }

  UserEntity copyWith({
    String? uId,
    String? name,
    String? email,
    String? photoUrl,
    bool? emailVerified,
    String? userStat,
    String? userState,
    String? bloodType,
  }) {
    return UserEntity(
      uId: uId ?? this.uId,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      emailVerified: emailVerified ?? this.emailVerified,
      userStat: userStat ?? this.userStat,
      userState: userState ?? this.userState,
      bloodType: bloodType ?? this.bloodType,
    );
  }

  @override
  List<Object?> get props => [
    uId,
    name,
    email,
    photoUrl,
    emailVerified,
    userStat,
    userState,
    bloodType,
  ];
}



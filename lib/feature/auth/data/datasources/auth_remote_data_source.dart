import 'dart:convert';
import 'dart:developer';

import 'package:blood_bank/constants.dart';
import 'package:blood_bank/core/services/shared_preferences_sengleton.dart';
import 'package:blood_bank/feature/auth/data/models/user_model.dart';
import 'package:blood_bank/feature/auth/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

abstract class AuthRemoteDataSource {
  Stream<User?> get authStateChanges;
  Future<User?> signInWithGoogle();
  Future<User?> signInWithFacebook();
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> signUpWithEmailAndPassword(String email, String password, String name);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<User?> getCurrentUser();
  Future<void> verifyEmail();
  Future<void> deleteAccount();

  Future<void> addUserData(UserEntity user);
  Future<UserEntity> getUserData(String uid);
  Future<void> saveUserData(UserEntity user);
  Future<bool> isEmailExists(String email);
  Future<bool> isUserExists(String uid);
}
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<User?> getCurrentUser() async => _firebaseAuth.currentUser;

  @override
  Future<void> signOut() async => await _firebaseAuth.signOut();

  @override
  Future<void> resetPassword(String email) async {
    final exists = await isEmailExists(email);
    if (!exists) throw FirebaseAuthException(code: 'EMAIL_NOT_FOUND', message: 'Email not found');
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<User?> signUpWithEmailAndPassword(String email, String password, String name) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    final user = credential.user!;
    await verifyEmail();
    final userEntity = UserEntity(name: name, email: email, uId: user.uid);
    await addUserData(userEntity);
    await saveUserData(userEntity);
    return user;
  }

  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    final user = credential.user!;
    final userEntity = await getUserData(user.uid);
    await saveUserData(userEntity);
    return user;
  }

  @override
  Future<User?> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) throw FirebaseAuthException(code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user!;
    final exists = await isUserExists(user.uid);

    final userEntity = UserModel.fromFirebaseUser(user);
    if (exists) {
      final data = await getUserData(user.uid);
      await saveUserData(data);
    } else {
      await addUserData(userEntity);
    }

    return user;
  }

  @override
  Future<User?> signInWithFacebook() async {
    final result = await FacebookAuth.instance.login();
    if (result.status != LoginStatus.success) {
      throw FirebaseAuthException(code: 'ERROR_FACEBOOK_LOGIN_FAILED', message: result.message ?? 'Facebook sign in failed');
    }

    final credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    return userCredential.user!;
  }

  @override
  Future<void> verifyEmail() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  @override
  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) await user.delete();
  }

  @override
  Future<void> addUserData(UserEntity user) async {
    final userMap = user.toMap();
    userMap['userStat'] = 'allowed';
    await _firestore.collection('users').doc(user.uId).set(userMap);
  }

  @override
  Future<UserEntity> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) throw FirebaseAuthException(code: 'USER_NOT_FOUND', message: 'User data not found');
    return UserModel.fromJson(doc.data()!);
  }

  @override
  Future<void> saveUserData(UserEntity user) async {
    final jsonData = jsonEncode(UserModel.fromEntity(user).toMap());
    await Prefs.setString(kUserData, jsonData);
    log('User data saved successfully. UserData: $jsonData');
  }

  @override
  Future<bool> isEmailExists(String email) async {
    final query = await _firestore.collection('users').where('email', isEqualTo: email).get();
    return query.docs.isNotEmpty;
  }

  @override
  Future<bool> isUserExists(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists;
  }
}


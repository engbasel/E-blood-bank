import 'package:blood_bank/feature/home/domain/repos/donation_analytics_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DonationAnalyticsRepoImpl implements DonationAnalyticsRepo {
  final FirebaseFirestore _firestore;

  DonationAnalyticsRepoImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<int> getDonorsCount() async {
    final result = await _firestore
        .collection('users')
        .where('userState', isEqualTo: 'donor')
        .count()
        .get();
    return result.count ?? 0;
  }

  @override
  Future<int> getInProgressCount() async {
    final result = await _firestore
        .collection('donations')
        .where('status', isEqualTo: 'in_progress')
        .count()
        .get();
    return result.count ?? 0;
  }

  @override
  Future<int> getNeedersCount() async {
    final result = await _firestore
        .collection('users')
        .where('userState', isEqualTo: 'need')
        .count()
        .get();
    return result.count ?? 0;
  }

  @override
  Future<int> getSuccessfulCount() async {
    try {
      final result =
          await _firestore.collection('successfulDonations').count().get();

      return result.count ?? 0;
    } catch (e) {
      debugPrint("Error fetching successful donation count: $e");
      return 0;
    }
  }
}

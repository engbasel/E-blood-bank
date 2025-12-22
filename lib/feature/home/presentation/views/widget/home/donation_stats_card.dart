import 'package:blood_bank/constants.dart';
import 'package:blood_bank/feature/home/data/repos/donation_analyics_repo_impl.dart';
import 'package:blood_bank/feature/home/domain/repos/donation_analytics_repo.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/custom_stats_widget.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/donations_card_skeleton.dart';
import 'package:flutter/material.dart';

class DonationStatsCard extends StatefulWidget {
  const DonationStatsCard({super.key});

  @override
  State<DonationStatsCard> createState() => _DonationStatsCardState();
}

class _DonationStatsCardState extends State<DonationStatsCard> {
  late final DonationAnalyticsRepo _repo;
  late final Future<List<int>> _statsFuture;

  @override
  void initState() {
    super.initState();

    _repo = DonationAnalyticsRepoImpl(
      firestore: kFirebaseFirestore,
    );

    _statsFuture = Future.wait([
      _repo.getDonorsCount(),
      _repo.getNeedersCount(),
      _repo.getInProgressCount(),
      _repo.getSuccessfulCount(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: _statsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return DonationStatsCardSkeleton();
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Failed to load statistics'));
        }

        final donors = snapshot.data![0];
        final needers = snapshot.data![1];
        final inProgress = snapshot.data![2];
        final successful = snapshot.data![3];

        final maxValue = [
          donors,
          needers,
          inProgress,
          successful,
        ].reduce((a, b) => a > b ? a : b);

        return CustomStatsWidget(
          donors: donors,
          needers: needers,
          inProgress: inProgress,
          successful: successful,
          maxValue: maxValue,
        );
      },
    );
  }
}

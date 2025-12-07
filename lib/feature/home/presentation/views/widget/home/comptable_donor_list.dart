
import 'package:blood_bank/core/widget/is_compitable_blood.dart';
import 'package:blood_bank/feature/home/presentation/views/donor_details.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/donation_request.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompatibleDonorsList extends StatelessWidget {
  final String bloodType;
  final String donationType;

  const CompatibleDonorsList({
    super.key,
    required this.bloodType,
    required this.donationType,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('donerRequest').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return RequestForDonationSkeletonListView();

        final donors = snapshot.data!.docs.map((doc) => doc.data()).where((donor) {
          return isCompatibleBlood(donor['bloodType'], bloodType) &&
              donor['donationType'].toLowerCase() == donationType.toLowerCase();
        }).toList();

        if (donors.isEmpty) {
          return Text('no_compatible_donors'.tr(context));
        }

        return Column(
          children: donors.map((donor) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: donor['photoUrl'] != null && donor['photoUrl'].isNotEmpty
                    ? NetworkImage(donor['photoUrl'])
                    : null,
                child: donor['photoUrl'] == null || donor['photoUrl'].isEmpty
                    ? const Icon(Icons.person)
                    : null,
              ),
              title: Text(donor['name']),
              subtitle: Text(donor['hospitalName']),
              trailing: Text(donor['bloodType']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DonorProfileScreen(uId: donor['uId']),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
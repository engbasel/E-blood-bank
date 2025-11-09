import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/widget/coustom_circular_progress_indicator.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/request_for_donation_list_view_item.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/see_all_button.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestsForDonation extends StatelessWidget {
  const RequestsForDonation({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('donerRequest').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CustomCircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('error: ${snapshot.error}'));
        }

        final requests = snapshot.data?.docs ?? [];

        final reversedRequests = requests.reversed.toList();

        if (reversedRequests.isEmpty) {
          return Center(
              child: Text('no_donation_requests_available'.tr(context)));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'donation_request'.tr(context),
                    style: TextStyles.semiBold16,
                  ),
                  SeeAll(
                    requests: reversedRequests,
                    snapshot: snapshot,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 350,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    reversedRequests.length >= 4 ? 4 : reversedRequests.length,
                itemBuilder: (context, index) {
                  final request = reversedRequests[index].data();

                  return RequestForDonationListViewItem(
                    request: request,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

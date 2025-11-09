import 'package:blood_bank/core/utils/page_rout_builder.dart';
import 'package:blood_bank/feature/home/presentation/views/donor_details.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/request_for_donation_list_view_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestForDonationListView extends StatelessWidget {
  const RequestForDonationListView({
    super.key,
    required this.reversedRequests,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> reversedRequests;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reversedRequests.length >= 4 ? 4 : reversedRequests.length,
      itemBuilder: (context, index) {
        final request = reversedRequests[index].data();

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              buildPageRoute(
                DonorProfileScreen(
                  uId: request['uId'],
                ),
              ),
            );
          },
          child: RequestForDonationListViewItem(
            request: request,
          ),
        );
      },
    );
  }
}

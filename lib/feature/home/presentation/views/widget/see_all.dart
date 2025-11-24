import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/page_rout_builder.dart';
import 'package:blood_bank/core/widget/coustom_circular_progress_indicator.dart';
import 'package:blood_bank/core/widget/coustom_dialog.dart';
import 'package:blood_bank/feature/home/presentation/views/donor_details.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/request_for_donation_list_view_item.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SeeAllScreen extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> requests;
  final AsyncSnapshot<dynamic> snapshot;

  const SeeAllScreen({
    super.key,
    required this.requests,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Requests', style: TextStyles.semiBold16),
        backgroundColor: const Color(0xff800000),
        foregroundColor: Colors.white,
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CustomCircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Center(
        child: CustomDialog(
          title: 'error_occurred'.tr(context),
          content: 'error_occurred: ${snapshot.error}'.tr(context),
        ),
      );
    }

    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index].data();
        return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                buildPageRoute(
                  DonorProfileScreen(uId: request['uId']),
                ),
              );
            },
            child: RequestForDonationListViewItem(request: request));

      },
    );
  }



}


import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/page_rout_builder.dart';
import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';
import 'package:blood_bank/feature/home/presentation/views/donor_details.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/request_for_donation_list_view_item.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class SeeAllScreen extends StatelessWidget {
  final List<DonorRequestEntity> requests;

  const SeeAllScreen({
    super.key,
    required this.requests,
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
    if (requests.isEmpty) {
      return Center(
        child: Text('no_donation_requests_available'.tr(context)),
      );
    }

    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              buildPageRoute(
                DonorProfileScreen(uId: request.uId),
              ),
            );
          },
          child: RequestForDonationListViewItem(request: request),
        );
      },
    );
  }
}


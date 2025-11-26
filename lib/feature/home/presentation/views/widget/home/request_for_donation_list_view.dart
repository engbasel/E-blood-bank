import 'package:blood_bank/core/utils/page_rout_builder.dart';
import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_bloc.dart';
import 'package:blood_bank/feature/home/presentation/views/donor_details.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/request_for_donation_list_view_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestForDonationListView extends StatelessWidget {
  final List<DonorRequestEntity> reversedRequests;

  const RequestForDonationListView({super.key, required this.reversedRequests});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reversedRequests.length >= 4 ? 4 : reversedRequests.length,
      itemBuilder: (context, index) {
        final request = reversedRequests[index];

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              buildPageRoute(

                BlocProvider.value(
                  value: context.read<DonorRequestsBloc>(),
                  child: DonorProfileScreen(uId: request.uId),
                ),
              ),
            );
          },
          child: RequestForDonationListViewItem(request: request),
        );
      },
    );
  }
}

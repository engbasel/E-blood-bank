import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_bloc.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_state.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/donation_request.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/request_for_donation_list_view.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/see_all_button.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestsForDonation extends StatelessWidget {
  const RequestsForDonation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DonorRequestsBloc, DonorRequestsState>(
      builder: (context, state) {
        if (state is DonorRequestsLoading) {
          return const Center(child: RequestForDonationSkeletonListView());
        }

        if (state is DonorRequestsFailure) {
          return Center(child: Text('error: ${state.message}'));
        }

        if (state is DonorRequestsLoaded) {
          final reversedRequests = state.requests.reversed.toList();

          if (reversedRequests.isEmpty) {
            return Center(
              child: Text('no_donation_requests_available'.tr(context)),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'donation_request'.tr(context),
                      style: TextStyles.semiBold16,
                    ),
                    SeeAll(
                      requests: reversedRequests,
                    ),
                  ],
                ),
              ),
              RequestForDonationListView(
                reversedRequests: reversedRequests,
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/page_rout_builder.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_needer_request_bloc/add_needer_request_bloc.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_needer_request_bloc/add_needer_request_state.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/donation_request.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/request_for_blood_list_view.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/needer_profile_screen.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/see_all_button.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcceptedRequestsSection extends StatelessWidget {
  const AcceptedRequestsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNeederRequestBloc, AddNeederRequestState>(
      builder: (context, state) {
        if (state is AcceptedNeederRequestsLoading) {
          return const Center(child: RequestForDonationSkeletonListView());
        }

        if (state is AcceptedNeederRequestsFailure) {
          return Center(child: Text('error: ${state.message}'));
        }

        if (state is AcceptedNeederRequestsLoaded || state is AddNeederRequestSuccess) {
          final acceptedRequests = state is AcceptedNeederRequestsLoaded
              ? state.requests
              : [];

          if (acceptedRequests.isEmpty) {
            return Center(
              child: Text('no_accepted_requests_available'.tr(context)),
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
                      'accepted_requests'.tr(context),
                      style: TextStyles.semiBold16,
                    ),
                    SeeAll(
                      requests: acceptedRequests,
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: acceptedRequests.length >= 4
                    ? 4
                    : acceptedRequests.length,
                itemBuilder: (context, index) {
                  final request = acceptedRequests[index];
                  return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          buildPageRoute(
                            BlocProvider.value(
                              value: context.read<AddNeederRequestBloc>(),
                              child: NeederProfileScreen(needer: request,),
                            ),
                          ),
                        );
                      },

                  child:  RequestForNeederListViewItem(request: request),
                  );
                },
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

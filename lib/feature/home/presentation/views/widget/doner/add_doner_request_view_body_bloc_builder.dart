import 'package:blood_bank/core/utils/custom_progrss_hud.dart';
import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/doner/add_doner_request.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_bloc.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_state.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddDonorRequestViewBodyBlocBuilder extends StatelessWidget {
  const AddDonorRequestViewBodyBlocBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddDonorRequestBloc, AddDonorRequestState>(
      listener: (context, state) {
        if (state is AddDonorRequestSuccess) {
          successTopSnackBar(context, 'product_added_successfully'.tr(context));
        }
        if (state is AddDonorRequestFailure) {
          failureTopSnackBar(context, 'something_went_wrong'.tr(context));
        }
      },
      builder: (context, state) {
        return CustomProgressHud(
            isLoading: state is AddDonorRequestLoading,
            child: const DonorRequest());
      },
    );
  }
}

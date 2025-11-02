import 'package:blood_bank/core/utils/custom_progrss_hud.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_needer_request_bloc/add_needer_request_bloc.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_needer_request_bloc/add_needer_request_state.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/need/add_need_request.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helper_function/scccess_top_snak_bar.dart';

class AddNeedRequestViewBodyBlocBuilder extends StatelessWidget {
  const AddNeedRequestViewBodyBlocBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNeederRequestBloc, AddNeederRequestState>(
      listener: (context, state) {
        if (state is AddNeederRequestSuccess) {
          successTopSnackBar(context, 'product_added_successfully'.tr(context));
        }
        if (state is AddNeederRequestFailure) {
          failureTopSnackBar(context, state.message.tr(context));
        }
      },
      builder: (context, state) {
        return CustomProgrssHud(
            isLoading: state is AddNeederRequestLoading,
            child: const NeedRequest());
      },
    );
  }
}

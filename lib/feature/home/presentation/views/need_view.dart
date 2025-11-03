import 'dart:developer';

import 'package:blood_bank/core/services/get_it_service.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blood_bank/feature/auth/presentation/bloc/auth_state.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_needer_request_bloc/add_needer_request_bloc.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/doner/custom_donner_drawer.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/need/add_need_request_view_body_bloc_builder.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NeedView extends StatelessWidget {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  NeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return CustomDonnerDrawer(userId: state.user.uId);
          } else {
            return const SizedBox();
          }
        },
      ),

      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(
            Icons.list_rounded,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          'blood_needed'.tr(context),
          style: TextStyles.semiBold19.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => getIt<AddNeederRequestBloc>(),
        child: const AddNeedRequestViewBodyBlocBuilder(),
      ),
    );
  }
}

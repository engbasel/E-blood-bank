import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/widget/coustom_circular_progress_indicator.dart';
import 'package:blood_bank/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blood_bank/feature/auth/presentation/bloc/auth_state.dart';
import 'package:blood_bank/feature/auth/presentation/view/login_view.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/home_header.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserHandler extends StatelessWidget {
  const UserHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {

        if (state is AuthLoading) {
          return const Center(child: CustomCircularProgressIndicator());
        }

        if (state is AuthError) {
          return Center(
            child: Text(
              'error_occurred'.tr(context),
              style: TextStyles.semiBold16.copyWith(
                color: AppColors.backgroundColor,
              ),
            ),
          );
        }

        if (state is Unauthenticated) {
          return const LoginView();
        }

        if (state is Authenticated) {
          return HomeHeader(

            name: state.user.name ??
                state.user.email?.split('@')[0] ??
                'Anonymous',
            photoUrl: state.user.photoUrl,
            userState: state.user.userState,

          );
        }

        return Container(
          alignment: Alignment.center,
          child: Text(
            'unknown_state'.tr(context),
            style: TextStyles.semiBold16.copyWith(
              color: AppColors.backgroundColor,
            ),
          ),
        );
      },
    );
  }
}

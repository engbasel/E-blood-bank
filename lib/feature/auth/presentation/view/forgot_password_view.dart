import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
import 'package:blood_bank/core/services/get_it_service.dart';
import 'package:blood_bank/core/utils/custom_progrss_hud.dart';
import 'package:blood_bank/core/widget/custom_app_bar.dart';
import 'package:blood_bank/feature/auth/domain/repositories/auth_repository.dart';
import 'package:blood_bank/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blood_bank/feature/auth/presentation/bloc/auth_state.dart';
import 'package:blood_bank/feature/auth/presentation/view/widget/forgot_password_view_body.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        top: 120,
        left: 50,
        title: 'forgot_password'.tr(context),
        leadingIcon: Icons.arrow_back_ios_new_rounded,
      ),
      body: ForgotPasswordViewBodyBlocConsumer(),
    );
  }
}

class ForgotPasswordViewBodyBlocConsumer extends StatelessWidget {
  const ForgotPasswordViewBodyBlocConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          // succesTopSnackBar(
          //     context,
          //     'password_reset_link_sent_to${state.userEntity.email}'
          //         .tr(context));

          successTopSnackBar(context,
              '${'password_reset_link_sent_to'.tr(context)} ${state.user.email}');
        } else if (state is AuthError) {
          failureTopSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        return CustomProgrssHud(
            isLoading: state is AuthLoading,
            child: const ForgotPasswordViewBody());
      },
    );
  }
}

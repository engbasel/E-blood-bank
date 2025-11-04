import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CustomProgressHud extends StatelessWidget {
  const CustomProgressHud({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: Center(
          child: CircularProgressIndicator(
            strokeWidth: 6.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.primaryColor,
            ),
            backgroundColor: AppColors.orangeColor.withValues(
              alpha: 0.5,
            )
          ),
        ),
        child: child,
      ),
    );
  }
}

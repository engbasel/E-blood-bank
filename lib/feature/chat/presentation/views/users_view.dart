import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/chat/presentation/views/widgets/users_view_body.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key, required this.currentUserId});
  final String currentUserId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'chat_title'.tr(context),
          style: TextStyles.semiBold19.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        elevation: 4,
        automaticallyImplyLeading: false,
      ),
      body: UsersViewBody(
        currentUserId: currentUserId,
      ),
    );
  }
}

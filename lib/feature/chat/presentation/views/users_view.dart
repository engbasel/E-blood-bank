import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

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
      // body: ChatViewBody(
      //   currentUserId: currentUserId,
      // ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 48.0),
        child: SizedBox(
          width: 64,
          height: 64,
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: AppColors.primaryColor,
            shape: const CircleBorder(),
            elevation: 6,
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
      ),
    );
  }
}

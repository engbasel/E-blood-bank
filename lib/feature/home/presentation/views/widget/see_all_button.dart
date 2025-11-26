import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/page_rout_builder.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/see_all.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class SeeAll<T> extends StatelessWidget {
  const SeeAll({
    super.key,
    required this.requests,
  });

  final List<T> requests;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          buildPageRoute(
            SeeAllScreen<T>(
              requests: requests,
            ),
          ),
        );
      },
      child: Text(
        'see_all'.tr(context),
        style: TextStyles.semiBold14.copyWith(color: Colors.grey),
      ),
    );
  }
}

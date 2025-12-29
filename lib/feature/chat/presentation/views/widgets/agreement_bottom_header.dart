import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class AgreementBottomHeader extends StatelessWidget {
  const AgreementBottomHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.handshake_outlined,
            color: Colors.green[700],
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Agreement Check'.tr(context),
                style: TextStyles.bold16.copyWith(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
              Text(
                'Did you reach an agreement with the donor?'.tr(context),
                style: TextStyles.regular16.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

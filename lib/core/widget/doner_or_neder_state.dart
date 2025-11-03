import 'package:flutter/material.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:blood_bank/core/utils/app_colors.dart';

class StateDropdown extends StatelessWidget {
  final String? selectedKey;
  final ValueChanged<String?> onChanged;

  const StateDropdown({
    super.key,
    this.selectedKey,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> states = [
      {
        'key': 'doner',
        'name': 'doner'.tr(context),
        'icon': Icons.bloodtype,
      },
      {
        'key': 'need',
        'name': 'need'.tr(context),
        'icon': Icons.bloodtype,
      },
    ];

    final validKeys = states.map((e) => e['key'] as String).toList();

    final safeSelectedKey = validKeys.contains(selectedKey) ? selectedKey : null;

    return DropdownButtonFormField<String>(
      value: safeSelectedKey,
      items: states.map((state) {
        return DropdownMenuItem<String>(
          value: state['key'] as String,
          child: Row(
            children: [
              Icon(
                state['icon'] as IconData,
                color: AppColors.lightPrimaryColor,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                state['name'] as String,
                style: TextStyles.semiBold14.copyWith(
                  color: AppColors.lightPrimaryColor,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'state'.tr(context),
        labelStyle: TextStyles.semiBold14.copyWith(
          color: AppColors.backgroundColor,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.lightPrimaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryColorB),
        ),
      ),
      icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryColor),
      validator: (value) => value == null ? 'user_state'.tr(context) : null,
      dropdownColor: AppColors.backgroundColor,
    );
  }
}


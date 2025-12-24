import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class HospitalDropdown extends StatelessWidget {
  final String? selectedHospital;
  final List<String> hospitals;
  final ValueChanged<String?> onChanged;

  const HospitalDropdown({
    super.key,
    required this.hospitals,
    this.selectedHospital,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: selectedHospital,
      items: hospitals.map((hospital) {
        return DropdownMenuItem<String>(
          value: hospital,
          child: Row(
            children: [
              Icon(
                Icons.local_hospital,
                color: AppColors.lightPrimaryColor,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  hospital.tr(context),
                  style: TextStyles.semiBold14.copyWith(
                    color: AppColors.lightPrimaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'select_hospital'.tr(context),
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
      validator: (value) =>
          value == null ? 'please_select_hospital'.tr(context) : null,
      dropdownColor: AppColors.backgroundColor,
      isExpanded: true,
    );
  }
}

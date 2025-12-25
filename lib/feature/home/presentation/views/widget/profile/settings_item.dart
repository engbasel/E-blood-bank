import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  final IconData? icon;

  const SettingsItem({
    super.key,
    required this.title,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyles.bold16,
      ),
      trailing: Icon(icon, size: 18),
      onTap: onTap,
    );
  }
}

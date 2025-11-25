import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomRequestTextField extends StatelessWidget {
  const CustomRequestTextField({
    super.key,
    required this.hintText,
    this.textInputType,
    this.suffixIcon,
    this.onSaved,
    this.obobscureText = false,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.onSubmitted,
    this.maxLines,
    this.readOnly = false,
    this.onTap,
    this.hintStyle,
    this.maxLength,
  });

  final String hintText;
  final TextInputType? textInputType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function(String?)? onSaved;
  final bool obobscureText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final void Function(String)? onSubmitted;
  final int? maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextStyle? hintStyle;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      inputFormatters: [
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength!),
        if (textInputType == TextInputType.number)
          FilteringTextInputFormatter.digitsOnly,
      ],
      style: TextStyles.semiBold14,
      controller: controller,
      obscureText: obobscureText,
      onSaved: onSaved,
      validator: validator,
      keyboardType: textInputType,
      onFieldSubmitted: onSubmitted,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: hintStyle,
        filled: true,
        fillColor: Colors.transparent,
        border: buildBorder(),
        enabledBorder: buildBorder(),
        focusedBorder: buildBorder(),
        counterText: '',
      ),
    );
  }

  OutlineInputBorder buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        width: 1,
        color: AppColors.primaryColor,
      ),
    );
  }
}

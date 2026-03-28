import 'package:flutter/material.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final TextEditingController? controller;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      controller: controller,
      style: AppTextStyles.bodyLg,
      decoration: InputDecoration(
        hintText: hintText.toUpperCase(),
        hintStyle: AppTextStyles.labelMd.copyWith(color: Colors.black26),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.4),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 24,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: AppColors.kPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: Colors.red.withValues(alpha: 0.5), width: 1.5),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: suffixIcon,
        ),
      ),
    );
  }
}

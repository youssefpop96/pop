import 'package:flutter/material.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final Size? minimumSize;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.minimumSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.kPrimary,
        borderRadius: BorderRadius.circular(borderRadius ?? 100),
        boxShadow: backgroundColor == null
            ? [
                BoxShadow(
                  color: AppColors.kPrimary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius ?? 100),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 22),
            constraints: BoxConstraints(
              minHeight: minimumSize?.height ?? 64,
              minWidth: minimumSize?.width ?? double.infinity,
            ),
            alignment: Alignment.center,
            child: Text(
              text.toUpperCase(),
              style: AppTextStyles.labelMd.copyWith(
                color: textColor ?? Colors.white,
                letterSpacing: 2.0,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

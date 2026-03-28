import 'package:flutter/material.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';

class SocialLoginButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback onTap;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(100),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  iconPath,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    label.toLowerCase().contains('google')
                        ? Icons.g_mobiledata_rounded
                        : Icons.facebook_rounded,
                    size: 24,
                    color: Colors.black38,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  label.toUpperCase(),
                  style: AppTextStyles.labelMd.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

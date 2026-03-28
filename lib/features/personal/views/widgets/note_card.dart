import 'package:flutter/material.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';

class NoteCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String timeText;
  final Color indicatorColor;
  final IconData? suffixIcon;
  final Color? suffixIconColor;
  final VoidCallback? onTap;

  const NoteCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.timeText,
    required this.indicatorColor,
    this.suffixIcon,
    this.suffixIconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Remove HTML tags for clean subtitle
    final cleanSubtitle = subtitle.replaceAll(RegExp(r'<[^>]*>'), '');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title.toUpperCase(),
                    style: AppTextStyles.headlineSm.copyWith(
                      fontSize: 18,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                if (suffixIcon != null)
                  Icon(
                    suffixIcon,
                    color: suffixIconColor ?? AppColors.kPrimary.withValues(alpha: 0.3),
                    size: 20,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              cleanSubtitle,
              style: AppTextStyles.bodyMd.copyWith(
                color: Colors.black54,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.kPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        timeText,
                        style: AppTextStyles.labelMd.copyWith(
                          color: AppColors.kPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

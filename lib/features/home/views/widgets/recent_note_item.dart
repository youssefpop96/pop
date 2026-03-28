import 'package:flutter/material.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';

class RecentNoteItem extends StatelessWidget {
  final String title;
  final String folderName;
  final String time;
  final Color indicatorColor;
  final VoidCallback? onTap;

  const RecentNoteItem({
    super.key,
    required this.title,
    required this.folderName,
    required this.time,
    required this.indicatorColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.6),
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: indicatorColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.description_rounded,
                color: indicatorColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: AppTextStyles.headlineSm.copyWith(
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    folderName.toUpperCase(),
                    style: AppTextStyles.labelMd.copyWith(
                      color: Colors.black38,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black12, size: 14),
                const SizedBox(height: 12),
                Text(
                  time.toUpperCase(),
                  style: AppTextStyles.labelMd.copyWith(
                    color: Colors.black26,
                    fontSize: 10,
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

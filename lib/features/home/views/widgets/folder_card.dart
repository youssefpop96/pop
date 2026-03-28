import 'package:flutter/material.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';

class FolderCard extends StatelessWidget {
  final String title;
  final String notesCount;
  final Color folderColor;
  final IconData? icon;
  final VoidCallback? onTap;

  const FolderCard({
    super.key,
    required this.title,
    required this.notesCount,
    required this.folderColor,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: folderColor.withValues(alpha: 0.2),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: folderColor.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: folderColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.folder_rounded,
                color: folderColor,
                size: 24,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: AppTextStyles.headlineSm.copyWith(
                    fontSize: 15,
                    letterSpacing: 0.5,
                    color: Colors.black87,
                    fontWeight: FontWeight.w900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  notesCount.toUpperCase(),
                  style: AppTextStyles.labelMd.copyWith(
                    color: Colors.black38,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
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

import 'package:flutter/material.dart';

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
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 48,
              decoration: BoxDecoration(
                color: indicatorColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.folder, color: indicatorColor, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        folderName,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(Icons.more_vert, color: Colors.black38, size: 20),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: const TextStyle(color: Colors.black38, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

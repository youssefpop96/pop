import 'package:flutter/material.dart';

class FolderCard extends StatelessWidget {
  final String title;
  final String notesCount;
  final List<Color> gradientColors;
  final IconData? icon;
  final VoidCallback? onTap;

  const FolderCard({
    super.key,
    required this.title,
    required this.notesCount,
    required this.gradientColors,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: gradientColors[1].withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notesCount,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (icon != null)
              Positioned(
                right: 0,
                bottom: 0,
                child: Icon(
                  icon,
                  color: Colors.white.withValues(alpha: 0.3),
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

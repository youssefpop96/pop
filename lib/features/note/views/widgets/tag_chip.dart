import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const TagChip({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          if (icon != null) ...[
            const SizedBox(width: 4),
            Icon(icon, color: textColor, size: 16),
          ],
        ],
      ),
    );
  }
}

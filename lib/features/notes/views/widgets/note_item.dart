import 'package:flutter/material.dart';

class NoteItem extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final bool isFavorite;
  final Color? statusColor;

  const NoteItem({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    this.isFavorite = false,
    this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              if (isFavorite)
                const Icon(Icons.star, color: Color(0xFFF59E0B), size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black45,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black26,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (statusColor != null)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

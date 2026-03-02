import 'package:flutter/material.dart';
import '../../models/note_model.dart';

class RecentNoteItem extends StatelessWidget {
  final NoteModel note;

  const RecentNoteItem({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Sidebar with category color
          Container(
            width: 4,
            height: 48,
            decoration: BoxDecoration(
              color: note.categoryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(note.icon, size: 14, color: Colors.black38),
                    const SizedBox(width: 6),
                    Text(
                      note.folder,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black38,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Time Ago
          Text(
            note.time,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black26,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

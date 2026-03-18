import 'package:flutter/material.dart';
import 'package:pop/core/models/folder_model.dart';
import 'package:pop/core/models/note_model.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/features/home/views/widgets/recent_note_item.dart';
import 'package:pop/features/note/views/screens/note_detail_screen.dart';

class HomeRecentNotesSection extends StatelessWidget {
  final List<NoteModel> notes;
  final List<FolderModel> folders;

  const HomeRecentNotesSection({
    super.key,
    required this.notes,
    required this.folders,
  });

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text('No notes yet. Add your first note!')),
      );
    }

    final List<List<Color>> gradientPool = [
      AppColors.kGradientBlue,
      AppColors.kGradientGreen,
      AppColors.kGradientPurple,
      AppColors.kGradientOrange,
      AppColors.kGradientPink,
      AppColors.kGradientTeal,
    ];

    return Column(
      children: notes.map((note) {
        // Find the folder name and color
        final folder = folders.firstWhere(
          (f) => f.id == note.folderId,
          orElse: () => FolderModel(
            id: '',
            userId: '',
            name: 'General',
            colorIndex: 0,
            createdAt: DateTime.now(),
          ),
        );

        final colorIndex = folder.colorIndex % gradientPool.length;
        final indicatorColor = gradientPool[colorIndex].first;

        return RecentNoteItem(
          title: note.title,
          folderName: folder.name,
          time: _formatDate(note.createdAt),
          indicatorColor: indicatorColor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteDetailScreen(note: note),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

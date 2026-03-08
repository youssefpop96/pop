import 'package:flutter/material.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/features/home/views/widgets/recent_note_item.dart';
import 'package:pop/features/note/views/screens/note_detail_screen.dart';

class HomeRecentNotesSection extends StatelessWidget {
  final List<dynamic> notes;

  const HomeRecentNotesSection({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text('No notes yet. Add your first note!')),
      );
    }
    return Column(
      children: notes.map((note) {
        return RecentNoteItem(
          title: note.title,
          folderName: 'General',
          time: 'Today',
          indicatorColor: AppColors.kPrimaryColor,
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
}

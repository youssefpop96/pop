import 'package:flutter/material.dart';
import 'package:pop/core/models/folder_model.dart';
import 'package:pop/core/models/note_model.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/features/home/views/widgets/folder_card.dart';
import 'package:pop/features/personal/views/screens/folder_detail_screen.dart';

class HomeFoldersSection extends StatelessWidget {
  final List<FolderModel> folders;
  final List<NoteModel> notes;

  const HomeFoldersSection({
    super.key,
    required this.folders,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    if (folders.isEmpty) return const SizedBox();

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: folders.length,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemBuilder: (context, index) {
          final folder = folders[index];

          // Get color based on colorIndex
          final color = AppColors.kFolderColors[folder.colorIndex % AppColors.kFolderColors.length];

          // Get icon based on iconName or fallback to colorIndex
          IconData iconData = Icons.folder_rounded;
          if (folder.iconName != null && folder.iconName!.startsWith('icon_')) {
            final iconIdx = int.tryParse(folder.iconName!.split('_')[1]) ?? 0;
            iconData = AppColors.kFolderIcons[iconIdx % AppColors.kFolderIcons.length];
          }

          // Calculate notes count for this folder
          final count = notes.where((note) => note.folderId == folder.id).length;
          final countLabel = count == 1 ? '1 Note' : '$count Notes';

          return Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 20),
            child: FolderCard(
              title: folder.name,
              notesCount: countLabel,
              folderColor: color,
              icon: iconData,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FolderDetailScreen(folder: folder),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

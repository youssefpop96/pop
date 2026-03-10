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

    final List<List<Color>> gradientPool = [
      AppColors.kGradientBlue,
      AppColors.kGradientGreen,
      AppColors.kGradientPurple,
      AppColors.kGradientOrange,
      [const Color(0xFFF44336), const Color(0xFFFF8A80)],
      [const Color(0xFFCDDC39), const Color(0xFFE6EE9C)],
    ];

    final List<IconData> iconPool = [
      Icons.folder,
      Icons.business_center,
      Icons.videocam,
      Icons.home,
      Icons.description,
      Icons.stars,
    ];

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: folders.length,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, index) {
          final folder = folders[index];

          // Calculate notes count for this folder
          final count = notes
              .where((note) => note.folderId == folder.id)
              .length;
          final countLabel = count == 1 ? '1 Note' : '$count Notes';

          final colorIndex = folder.colorIndex % gradientPool.length;

          int iconIndex = 0;
          if (folder.iconName != null && folder.iconName!.startsWith('icon_')) {
            iconIndex = int.tryParse(folder.iconName!.split('_')[1]) ?? 0;
            iconIndex = iconIndex % iconPool.length;
          } else {
            iconIndex = folder.colorIndex % iconPool.length;
          }

          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FolderCard(
              title: folder.name,
              notesCount: countLabel,
              gradientColors: gradientPool[colorIndex],
              icon: iconPool[iconIndex],
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

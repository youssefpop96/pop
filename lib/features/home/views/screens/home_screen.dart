import 'package:flutter/material.dart';

import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/features/home/views/widgets/custom_search_bar.dart';
import 'package:pop/features/home/views/widgets/folder_card.dart';
import 'package:pop/features/home/views/widgets/recent_note_item.dart';
import 'package:pop/features/note/views/screens/add_note_screen.dart';
import 'package:pop/features/note/views/screens/note_detail_screen.dart';
import 'package:pop/features/personal/views/screens/personal_screen.dart';
import 'package:pop/features/work/views/screens/work_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomSearchBar(),
            const SizedBox(height: 20),
            _buildCreateFolderButton(),
            const SizedBox(height: 24),
            _buildFoldersGrid(context),
            const SizedBox(height: 32),
            _buildRecentNotesTitle(),
            const SizedBox(height: 16),
            _buildRecentNotesList(context),
            const SizedBox(height: 100), // spacing for FAB
          ],
        ),
      ),
      floatingActionButton: _buildFloatingAddButton(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.sort, color: Colors.black),
        onPressed: () {},
      ),
      title: const Text(
        'My Folders',
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () {},
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCreateFolderButton() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppColors.kGradientBlue.first),
            const SizedBox(width: 8),
            const Text(
              'Create New Folder',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoldersGrid(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              FolderCard(
                title: 'Personal',
                notesCount: '12 Notes',
                gradientColors: AppColors.kGradientBlue,
                icon: Icons.person_outline,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PersonalScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              const FolderCard(
                title: 'Study',
                notesCount: '15 Notes',
                gradientColors: AppColors.kGradientPurple,
                icon: Icons.school_outlined,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              FolderCard(
                title: 'Work',
                notesCount: '8 Notes',
                gradientColors: AppColors.kGradientGreen,
                icon: Icons.work_outline,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WorkScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),
              const FolderCard(
                title: 'Ideas',
                notesCount: '6 Notes',
                gradientColors: AppColors.kGradientOrange,
                icon: Icons.lightbulb_outline,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentNotesTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recent Notes',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: const [
            Text(
              'View All',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentNotesList(BuildContext context) {
    return Column(
      children: [
        RecentNoteItem(
          title: 'Shopping List',
          folderName: 'Personal',
          time: 'Today',
          indicatorColor: AppColors.kPrimaryColor, // Pink
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NoteDetailScreen()),
            );
          },
        ),
        RecentNoteItem(
          title: 'Meeting Summary',
          folderName: 'Work',
          time: 'Yesterday',
          indicatorColor: AppColors.kGradientGreen.first, // Green
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NoteDetailScreen()),
            );
          },
        ),
        RecentNoteItem(
          title: 'Lecture 5',
          folderName: 'Study',
          time: '2 days ago',
          indicatorColor: AppColors.kGradientPurple.first, // Purple
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NoteDetailScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFloatingAddButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(
          0xFF0061FF,
        ), // Same blue as "Personal" gradient start
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0061FF).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.add, color: Colors.white, size: 28),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNoteScreen()),
          );
        },
      ),
    );
  }
}

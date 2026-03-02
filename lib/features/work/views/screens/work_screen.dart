import 'package:flutter/material.dart';

import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/features/personal/views/widgets/note_card.dart';
import 'package:pop/features/note/views/screens/add_note_screen.dart';

class WorkScreen extends StatelessWidget {
  const WorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kLightGreyColor,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderCard(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  NoteCard(
                    title: 'Meeting Summary',
                    subtitle: 'Project discussion...',
                    timeText: 'Today, 11:00 AM',
                    indicatorColor: AppColors.kGradientGreen.first,
                    suffixIcon: Icons.star,
                    suffixIconColor: AppColors.kGradientOrange.first,
                  ),
                  NoteCard(
                    title: 'Project Plan',
                    subtitle: 'Design, Development...',
                    timeText: 'Yesterday',
                    indicatorColor: AppColors.kGradientGreen.first,
                    suffixIcon: Icons.check_circle,
                    suffixIconColor: Colors.black54,
                  ),
                  NoteCard(
                    title: 'Tasks',
                    subtitle: 'UI Design, APIs...\n3/5 done',
                    timeText: '', // Using empty timeText for UI matching layout
                    indicatorColor: Colors.transparent, // hiding indicator
                  ),
                  NoteCard(
                    title: 'Clients',
                    subtitle: 'Contact, Email...',
                    timeText: 'Aug 22, 2022',
                    indicatorColor: Colors.transparent, // hiding indicator
                    suffixIcon: Icons.more_vert,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingAddButton(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.sort, color: Colors.black),
        onPressed: () {},
      ),
      title: const Text(
        'Work',
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.kGradientGreen,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.folder,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Work',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '8 Notes',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: AppColors.kGradientGreen.first),
                const SizedBox(width: 8),
                const Text(
                  'Add New Note',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingAddButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kGradientGreen.first,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.kGradientGreen.first.withOpacity(0.4),
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

import 'package:flutter/material.dart';

import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/features/personal/views/widgets/note_card.dart';
import 'package:pop/features/note/views/screens/add_note_screen.dart';

class PersonalScreen extends StatelessWidget {
  const PersonalScreen({super.key});

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
                    title: 'My Diary',
                    subtitle: 'Today was a great day...',
                    timeText: 'Today, 10:30 AM',
                    indicatorColor: AppColors.kGradientBlue.first,
                    suffixIcon: Icons.push_pin,
                    suffixIconColor: AppColors.kGradientOrange.first,
                  ),
                  NoteCard(
                    title: 'Shopping List',
                    subtitle: 'Milk, Eggs, Bread...',
                    timeText: 'Today, 9:15 AM',
                    indicatorColor: AppColors.kPrimaryColor,
                    suffixIcon: Icons.shopping_cart_outlined,
                  ),
                  NoteCard(
                    title: 'Travel Plan',
                    subtitle: 'Visit Paris, Rome...',
                    timeText: 'Yesterday',
                    indicatorColor: AppColors.kGradientOrange.first,
                    suffixIcon: Icons.more_vert,
                  ),
                  NoteCard(
                    title: 'Birthday Ideas',
                    subtitle: 'Gift, Cake, Party...',
                    timeText: 'Aug 20, 2022',
                    indicatorColor: Colors.black26,
                    suffixIcon: Icons.cake_outlined,
                    suffixIconColor: Colors.yellow[700],
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
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Personal',
        style: TextStyle(
          color: Color(0xFF0061FF),
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
                colors: AppColors.kGradientBlue,
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
                      'Personal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '12 Notes',
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
                Icon(Icons.add, color: AppColors.kGradientBlue.first),
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
        color: AppColors.kGradientBlue.first,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.kGradientBlue.first.withOpacity(0.4),
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

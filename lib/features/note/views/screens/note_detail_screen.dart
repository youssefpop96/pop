import 'package:flutter/material.dart';

import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/features/note/views/widgets/tag_chip.dart';

class NoteDetailScreen extends StatelessWidget {
  const NoteDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateHeader(),
              const SizedBox(height: 20),
              _buildNoteContent(),
              const SizedBox(height: 24),
              _buildPhotosSection(),
              const SizedBox(height: 24),
              _buildTagsSection(),
              const SizedBox(height: 100), // padding for bottom bar
            ],
          ),
        ),
      ),
      bottomSheet: _buildBottomMenuBar(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'My Diary',
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildDateHeader() {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.kGradientBlue.first,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Today, August 25',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildNoteContent() {
    return const Text(
      'Today was a great day!\nI completed all my tasks and had a productive meeting with the team. In the evening, I went to the gym and felt great afterwards. Looking forward to tomorrow!',
      style: TextStyle(fontSize: 18, color: Colors.black87, height: 1.6),
    );
  }

  Widget _buildPhotosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Photos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              height: 70,
              width: 70,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage(
                    'assets/placeholder_img1.jpg',
                  ), // Ensure an asset is uploaded here later
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 70,
              width: 70,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage(
                    'assets/placeholder_img2.jpg',
                  ), // Ensure an asset is uploaded here later
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: AppColors.kOnboardingPeach,
                borderRadius: BorderRadius.circular(16),
                image: null,
              ),
              child: const Icon(Icons.add, color: Colors.orange, size: 30),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tags',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            TagChip(
              label: 'Personal',
              backgroundColor: AppColors.kGradientBlue.first.withOpacity(0.1),
              textColor: AppColors.kGradientBlue.first,
            ),
            TagChip(
              label: 'Daily',
              backgroundColor: AppColors.kPrimaryColor.withOpacity(0.1),
              textColor: AppColors.kPrimaryColor,
            ),
            TagChip(
              label: 'Life',
              backgroundColor: AppColors.kGradientBlue.first.withOpacity(0.1),
              textColor: AppColors.kGradientBlue.first,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomMenuBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Colors.black54),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.star_border, color: Colors.black54),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black54,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.folder_outlined, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

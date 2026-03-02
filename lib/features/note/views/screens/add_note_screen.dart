import 'package:flutter/material.dart';

import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/core/components/custom_text_form_field.dart';
import 'package:pop/core/components/custom_elevated_button.dart';
import 'package:pop/features/note/views/widgets/tag_chip.dart';

class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldTitle('Title'),
            const SizedBox(height: 8),
            CustomTextFormField(hintText: 'Work Title'),
            const SizedBox(height: 24),
            _buildFieldTitle('Content'),
            const SizedBox(height: 8),
            _buildContentEditor(),
            const SizedBox(height: 24),
            _buildFieldTitle('Folder'),
            const SizedBox(height: 8),
            _buildFolderSelector(),
            const SizedBox(height: 24),
            _buildFieldTitle('Tags'),
            const SizedBox(height: 8),
            CustomTextFormField(hintText: 'Add Tags...'),
            const SizedBox(height: 12),
            _buildAddedTags(),
            const SizedBox(height: 40),
            CustomElevatedButton(text: 'Save Note', onPressed: () {}),
            const SizedBox(height: 40),
          ],
        ),
      ),
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
        'Add New Note',
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildFieldTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildContentEditor() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          TextFormField(
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Start typing your note...',
              hintStyle: const TextStyle(color: Colors.black38),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Icon(Icons.format_align_left, color: Colors.black54),
                const SizedBox(width: 16),
                Icon(Icons.format_bold, color: Colors.black54),
                const SizedBox(width: 16),
                Icon(Icons.format_italic, color: Colors.black54),
                const SizedBox(width: 16),
                Icon(Icons.image_outlined, color: Colors.black54),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.kLightGreyColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.kGradientBlue.first,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.folder, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 12),
              const Text(
                'Personal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _buildAddedTags() {
    return Row(
      children: [
        TagChip(
          label: 'Tagement',
          backgroundColor: AppColors.kGradientOrange.first.withOpacity(0.1),
          textColor: AppColors.kGradientOrange.first,
          icon: Icons.push_pin,
        ),
        TagChip(
          label: 'Personal',
          backgroundColor: AppColors.kGradientBlue.first.withOpacity(0.1),
          textColor: AppColors.kGradientBlue.first,
          icon: Icons.close,
        ),
      ],
    );
  }
}

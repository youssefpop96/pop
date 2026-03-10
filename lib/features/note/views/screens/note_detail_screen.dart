import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/features/note/views/widgets/tag_chip.dart';
import 'package:pop/core/models/note_model.dart';
import 'package:pop/features/note/view_models/cubit/note_cubit.dart';
import 'package:pop/features/note/view_models/cubit/note_state.dart';
import 'package:pop/features/note/views/screens/add_note_screen.dart';

class NoteDetailScreen extends StatelessWidget {
  final NoteModel note;
  const NoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteCubit, NoteState>(
      builder: (context, state) {
        NoteModel currentNote = note;
        if (state is NoteSuccess) {
          currentNote = state.recentNotes.firstWhere(
            (n) => n.id == note.id,
            orElse: () => note,
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(context, currentNote),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateHeader(currentNote.createdAt),
                  const SizedBox(height: 20),
                  _buildNoteContent(currentNote.title, currentNote.content),
                  const SizedBox(height: 24),
                  _buildPhotosSection(context, currentNote),
                  const SizedBox(height: 24),
                  _buildTagsSection(currentNote.tags),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          bottomSheet: _buildBottomMenuBar(),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, NoteModel currentNote) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Note Detail',
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddNoteScreen(existingNote: currentNote),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () => _showDeleteDialog(context, currentNote),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, NoteModel currentNote) {
    showDialog(
      context: context,
      builder: (diagContext) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(diagContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<NoteCubit>().deleteNote(currentNote.id);
              Navigator.pop(diagContext);
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Note deleted')));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(DateTime date) {
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
        Text(
          '${date.day}/${date.month}/${date.year}',
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildNoteContent(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black87,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildPhotosSection(BuildContext context, NoteModel currentNote) {
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              if (currentNote.images.isEmpty)
                const Text(
                  'No photos added yet',
                  style: TextStyle(color: Colors.black38),
                ),
              ...currentNote.images.map(
                (img) => Container(
                  height: 70,
                  width: 70,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(img),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final cubit = context.read<NoteCubit>();
                  final picker = ImagePicker();
                  final image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    final url = await cubit.uploadImage(File(image.path));
                    final updatedImages = List<String>.from(currentNote.images)
                      ..add(url);
                    await cubit.updateNote(
                      currentNote.copyWith(images: updatedImages),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Image added!')),
                      );
                    }
                  }
                },
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: AppColors.kOnboardingPeach,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.add, color: Colors.orange, size: 30),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection(List<String> tags) {
    if (tags.isEmpty) return const SizedBox();
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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags
              .map(
                (tag) => TagChip(
                  label: tag,
                  backgroundColor: AppColors.kGradientBlue.first.withValues(
                    alpha: 0.1,
                  ),
                  textColor: AppColors.kGradientBlue.first,
                ),
              )
              .toList(),
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
          const Icon(Icons.home_outlined, color: Colors.black54),
          const Icon(Icons.star_border, color: Colors.black54),
          const Icon(Icons.shopping_bag_outlined, color: Colors.black54),
          const Icon(Icons.folder_outlined, color: Colors.black54),
        ],
      ),
    );
  }
}

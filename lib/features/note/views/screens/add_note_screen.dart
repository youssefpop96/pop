import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/core/components/custom_text_form_field.dart';
import 'package:pop/core/components/custom_elevated_button.dart';
import 'package:pop/features/note/views/widgets/tag_chip.dart';
import 'package:pop/features/note/view_models/cubit/note_cubit.dart';
import 'package:pop/features/note/view_models/cubit/note_state.dart';
import 'package:pop/core/models/folder_model.dart';
import 'package:pop/core/models/note_model.dart';

class AddNoteScreen extends StatefulWidget {
  final String? initialFolderId;
  final NoteModel? existingNote;
  const AddNoteScreen({super.key, this.initialFolderId, this.existingNote});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  String? selectedFolderId;
  List<String> tags = [];
  List<String> imageUrls = [];
  bool isUploading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.existingNote != null) {
      titleController.text = widget.existingNote!.title;
      contentController.text = widget.existingNote!.content;
      selectedFolderId = widget.existingNote!.folderId;
      tags = List.from(widget.existingNote!.tags);
      imageUrls = List.from(widget.existingNote!.images);
    } else {
      selectedFolderId = widget.initialFolderId;
    }
  }

  Future<void> _pickImage() async {
    final cubit = context.read<NoteCubit>();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => isUploading = true);
      try {
        final url = await cubit.uploadImage(File(image.path));
        if (!mounted) return;
        setState(() {
          imageUrls.add(url);
          isUploading = false;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() => isUploading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
      }
    }
  }

  void _insertText(String prefix, String suffix) {
    final text = contentController.text;
    final selection = contentController.selection;

    // Ensure selection is valid
    final start = selection.start < 0 ? text.length : selection.start;
    final end = selection.end < 0 ? text.length : selection.end;

    final before = text.substring(0, start);
    final selectedText = text.substring(start, end);
    final after = text.substring(end);

    final newText = '$before$prefix$selectedText$suffix$after';
    contentController.text = newText;
    contentController.selection = TextSelection.collapsed(
      offset: start + prefix.length + selectedText.length + suffix.length,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.existingNote != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, isEditing),
      body: BlocBuilder<NoteCubit, NoteState>(
        builder: (context, state) {
          List<FolderModel> folders = [];
          if (state is NoteSuccess) {
            folders = state.folders;
            if (selectedFolderId == null && folders.isNotEmpty) {
              selectedFolderId = folders.first.id;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldTitle('Title'),
                const SizedBox(height: 8),
                CustomTextFormField(
                  hintText: 'Note Title',
                  controller: titleController,
                ),
                const SizedBox(height: 24),
                _buildFieldTitle('Content'),
                const SizedBox(height: 8),
                _buildContentEditor(),
                const SizedBox(height: 12),
                if (isUploading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Uploading image...',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                _buildImageGrid(),
                const SizedBox(height: 24),
                _buildFieldTitle('Folder'),
                const SizedBox(height: 8),
                _buildFolderSelector(folders),
                const SizedBox(height: 24),
                _buildFieldTitle('Tags'),
                const SizedBox(height: 8),
                CustomTextFormField(
                  hintText: 'Type tag and press Enter...',
                  controller: tagController,
                  onFieldSubmitted: (val) {
                    if (val.isNotEmpty) {
                      setState(() {
                        tags.add(val);
                        tagController.clear();
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                _buildAddedTags(),
                const SizedBox(height: 40),
                CustomElevatedButton(
                  text: isEditing ? 'Update Note' : 'Save Note',
                  onPressed: () {
                    if (titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a title')),
                      );
                      return;
                    }
                    if (selectedFolderId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a folder')),
                      );
                      return;
                    }

                    if (isEditing) {
                      context.read<NoteCubit>().updateNote(
                        widget.existingNote!.copyWith(
                          title: titleController.text,
                          content: contentController.text,
                          folderId: selectedFolderId!,
                          tags: tags,
                          images: imageUrls,
                        ),
                      );
                    } else {
                      context.read<NoteCubit>().addNote(
                        title: titleController.text,
                        content: contentController.text,
                        folderId: selectedFolderId!,
                        tags: tags,
                        images: imageUrls,
                      );
                    }

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isEditing
                              ? 'Note Updated Successfully!'
                              : 'Note Saved Successfully!',
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, bool isEditing) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        isEditing ? 'Edit Note' : 'Add New Note',
        style: const TextStyle(
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
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          TextFormField(
            controller: contentController,
            maxLines: null,
            minLines: 8,
            decoration: const InputDecoration(
              hintText: 'Start typing your note...',
              hintStyle: TextStyle(color: Colors.black38),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                const Icon(Icons.format_align_left, color: Colors.blueAccent),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.format_bold, color: Colors.black54),
                  onPressed: () => _insertText('**', '**'),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.format_italic, color: Colors.black54),
                  onPressed: () => _insertText('*', '*'),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.image_outlined, color: Colors.black54),
                  onPressed: _pickImage,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    if (imageUrls.isEmpty) return const SizedBox();
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.only(right: 12, top: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(imageUrls[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 4,
                top: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      imageUrls.removeAt(index);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFolderSelector(List<FolderModel> folders) {
    String folderName = 'Select Folder';
    if (selectedFolderId != null && folders.isNotEmpty) {
      final selected = folders.firstWhere(
        (f) => f.id == selectedFolderId,
        orElse: () => folders.first,
      );
      folderName = selected.name;
    }

    return GestureDetector(
      onTap: () {
        _showFolderPicker(folders);
      },
      child: Container(
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
                  child: const Icon(
                    Icons.folder,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  folderName,
                  style: const TextStyle(
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
      ),
    );
  }

  void _showFolderPicker(List<FolderModel> folders) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Folder',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: folders.length,
                  itemBuilder: (context, index) {
                    final folder = folders[index];
                    return ListTile(
                      leading: const Icon(Icons.folder, color: Colors.blue),
                      title: Text(folder.name),
                      onTap: () {
                        setState(() {
                          selectedFolderId = folder.id;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddedTags() {
    return Wrap(
      spacing: 8,
      children: tags
          .map(
            (tag) => TagChip(
              label: tag,
              backgroundColor: AppColors.kGradientBlue.first.withValues(
                alpha: 0.1,
              ),
              textColor: AppColors.kGradientBlue.first,
              icon: Icons.close,
              onTap: () {
                setState(() {
                  tags.remove(tag);
                });
              },
            ),
          )
          .toList(),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/features/note/view_models/cubit/note_cubit.dart';
import 'package:pop/features/note/view_models/cubit/note_state.dart';
import 'package:pop/core/models/folder_model.dart';
import 'package:pop/core/models/note_model.dart';
import 'package:pop/features/note/views/widgets/tag_chip.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';
import 'package:pop/features/note/views/screens/note_editor_canvas.dart';
import 'package:pop/core/components/custom_text_form_field.dart';
import 'package:pop/core/components/custom_elevated_button.dart';

class AddNoteScreen extends StatefulWidget {
  final String? initialFolderId;
  final NoteModel? existingNote;
  const AddNoteScreen({super.key, this.initialFolderId, this.existingNote});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  
  dynamic noteContent; 
  String? selectedFolderId;
  List<String> tags = [];
  List<String> imageUrls = [];
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingNote != null) {
      titleController.text = widget.existingNote!.title;
      selectedFolderId = widget.existingNote!.folderId;
      tags = List.from(widget.existingNote!.tags);
      imageUrls = List.from(widget.existingNote!.images);
      noteContent = widget.existingNote!.content;
    } else {
      selectedFolderId = widget.initialFolderId;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    tagController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => isUploading = true);
      try {
        if (!mounted) return;
        final cubit = context.read<NoteCubit>();
        final url = await cubit.uploadImage(File(image.path));
        if (mounted) {
          setState(() {
            imageUrls.add(url);
            isUploading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() => isUploading = false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.existingNote != null;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.kBackground,
        gradient: LinearGradient(
          colors: [AppColors.kBackground, AppColors.kSurfaceLow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
              padding: const EdgeInsets.symmetric(horizontal: 28),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  _buildFieldTitle('TITLE'),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    hintText: 'Enter title...',
                    controller: titleController,
                  ),
                  const SizedBox(height: 32),
                  
                  _buildFieldTitle('CONTENT'),
                  const SizedBox(height: 12),
                  // "Design Paper" Button
                  InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteEditorCanvas(initialContent: noteContent),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          noteContent = result;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20),
                        ],
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.kPrimary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit_note_rounded, color: AppColors.kPrimary, size: 32),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('DESIGN PAPER', style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text(
                                  noteContent == null ? 'Tap to start expressing yourself...' : 'Content ready - Tap to edit',
                                  style: AppTextStyles.labelMd.copyWith(color: Colors.black26, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black12, size: 16),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                  _buildFieldTitle('FOLDER'),
                  const SizedBox(height: 12),
                  _buildFolderSelector(folders),
                  
                  const SizedBox(height: 32),
                  _buildFieldTitle('TAGS'),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    hintText: 'Add a tag...',
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
                  
                  const SizedBox(height: 32),
                  _buildFieldTitle('PHOTOS'),
                  const SizedBox(height: 12),
                  _buildImageGrid(),
                  if (isUploading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    ),
                  
                  const SizedBox(height: 64),
                  CustomElevatedButton(
                    text: isEditing ? 'UPDATE THOUGHT' : 'SAVE THOUGHT',
                    onPressed: _saveNote,
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, bool isEditing) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Center(
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.kPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: Text(
        isEditing ? 'EDIT THOUGHT' : 'NEW THOUGHT',
        style: AppTextStyles.headlineLg.copyWith(fontSize: 18, letterSpacing: 4, fontWeight: FontWeight.w900),
      ),
      centerTitle: true,
    );
  }

  Widget _buildFieldTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.labelMd.copyWith(letterSpacing: 2, color: Colors.black26, fontSize: 10, fontWeight: FontWeight.w900),
    );
  }

  Widget _buildImageGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: imageUrls.asMap().entries.map((entry) {
        return Stack(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(image: NetworkImage(entry.value), fit: BoxFit.cover),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () => setState(() => imageUrls.removeAt(entry.key)),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                  child: const Icon(Icons.close, color: Colors.white, size: 10),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildFolderSelector(List<FolderModel> folders) {
    String folderName = 'SELECT FOLDER';
    if (selectedFolderId != null && folders.isNotEmpty) {
      final selected = folders.firstWhere((f) => f.id == selectedFolderId, orElse: () => folders.first);
      folderName = selected.name.toUpperCase();
    }

    return GestureDetector(
      onTap: () => _showFolderPicker(folders),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.folder_rounded, color: AppColors.kPrimary, size: 24),
                const SizedBox(width: 16),
                Text(folderName, style: AppTextStyles.headlineSm.copyWith(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1)),
              ],
            ),
            const Icon(Icons.arrow_drop_down_rounded, color: Colors.black26),
          ],
        ),
      ),
    );
  }

  void _showFolderPicker(List<FolderModel> folders) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('SELECT FOLDER', style: AppTextStyles.labelMd.copyWith(letterSpacing: 2, color: Colors.black26, fontSize: 10, fontWeight: FontWeight.w900)),
            const SizedBox(height: 24),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: folders.length,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.folder_rounded, color: AppColors.kPrimary),
                  title: Text(folders[index].name, style: AppTextStyles.headlineSm.copyWith(fontSize: 16)),
                  onTap: () {
                    setState(() => selectedFolderId = folders[index].id);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddedTags() {
    return Wrap(
      spacing: 8,
      children: tags.map((t) => TagChip(
        label: t,
        backgroundColor: AppColors.kPrimary.withValues(alpha: 0.1),
        textColor: AppColors.kPrimary,
        onTap: () => setState(() => tags.remove(t)),
        icon: Icons.close_rounded,
      )).toList(),
    );
  }

  Future<void> _saveNote() async {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PLEASE ENTER A TITLE')));
      return;
    }
    
    final cubit = context.read<NoteCubit>();
    if (widget.existingNote != null) {
      await cubit.updateNote(
        widget.existingNote!.copyWith(
          title: titleController.text,
          content: noteContent ?? '',
          folderId: selectedFolderId!,
          tags: tags,
          images: imageUrls,
        ),
      );
    } else {
      await cubit.addNote(
        title: titleController.text,
        content: noteContent ?? '',
        folderId: selectedFolderId!,
        tags: tags,
        images: imageUrls,
      );
    }
    if (mounted) Navigator.pop(context);
  }
}

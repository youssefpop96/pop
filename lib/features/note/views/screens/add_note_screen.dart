import 'dart:convert';
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
import 'package:flutter_quill/flutter_quill.dart';

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
  late QuillController _controller;
  final ScrollController _scrollController = ScrollController();

  String? selectedFolderId;
  List<String> tags = [];
  List<String> imageUrls = [];
  bool isUploading = false;
  int pageCount = 1;

  @override
  void initState() {
    super.initState();
    _initEditor();
    if (widget.existingNote != null) {
      titleController.text = widget.existingNote!.title;
      selectedFolderId = widget.existingNote!.folderId;
      tags = List.from(widget.existingNote!.tags);
      imageUrls = List.from(widget.existingNote!.images);
    } else {
      selectedFolderId = widget.initialFolderId;
    }
  }

  void _initEditor() {
    if (widget.existingNote != null &&
        widget.existingNote!.content.isNotEmpty) {
      try {
        final doc = Document.fromJson(
          jsonDecode(widget.existingNote!.content),
        );
        _controller = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        _controller = QuillController.basic();
      }
    } else {
      _controller = QuillController.basic();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    tagController.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addPage() {
    setState(() {
      pageCount++;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.existingNote != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
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

          return Column(
            children: [
              _buildToolbar(),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Title & Meta Info Card
                      _buildHeaderInfo(folders),
                      const SizedBox(height: 20),
                      // Paper Sheets
                      ...List.generate(
                        pageCount,
                        (index) => _buildPaperSheet(index),
                      ),
                      // Add Page Action
                      _buildAddPageButton(),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderInfo(List<FolderModel> folders) {
    String folderName = 'Select Folder';
    if (selectedFolderId != null && folders.isNotEmpty) {
      final selected = folders.firstWhere(
        (f) => f.id == selectedFolderId,
        orElse: () => folders.first,
      );
      folderName = selected.name;
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: titleController,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              hintText: 'Untitled Document',
              border: InputBorder.none,
            ),
          ),
          const Divider(),
          Row(
            children: [
              // Folder Selector
              InkWell(
                onTap: () => _showFolderPicker(folders),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.folder_open,
                        size: 16,
                        color: AppColors.kPrimaryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        folderName,
                        style: const TextStyle(
                          color: AppColors.kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Tag Adder
              Expanded(
                child: TextField(
                  controller: tagController,
                  onSubmitted: (val) {
                    if (val.isNotEmpty) {
                      setState(() {
                        tags.add(val);
                        tagController.clear();
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Add Tag...',
                    isDense: true,
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: tags
                  .map(
                    (t) => TagChip(
                      label: t,
                      onTap: () => setState(() => tags.remove(t)),
                      icon: Icons.close,
                      backgroundColor: AppColors.kPrimaryColor.withOpacity(0.1),
                      textColor: AppColors.kPrimaryColor,
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaperSheet(int index) {
    double width = MediaQuery.of(context).size.width * 0.92;
    double height = width * 1.41;

    return Center(
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: index == 0
            ? Padding(
                padding: const EdgeInsets.all(45),
                child: QuillEditor.basic(
                  controller: _controller,
                  configurations: const QuillEditorConfigurations(
                    placeholder: 'Start writing your document...',
                    expands: true,
                  ),
                ),
              )
            : Stack(
                children: [
                  Positioned(
                    right: 20,
                    bottom: 20,
                    child: Text(
                      'Page ${index + 1}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "Content continues from previous page",
                      style: TextStyle(color: Colors.black12, fontSize: 14),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildAddPageButton() {
    return InkWell(
      onTap: _addPage,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_circle, color: Colors.blue, size: 20),
            SizedBox(width: 8),
            Text("Add Page"),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, bool isEditing) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        TextButton(
          onPressed: _saveNote,
          child: const Text(
            'Save',
            style: TextStyle(
              color: AppColors.kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolbar() {
    return Container(
      color: Colors.white,
      child: QuillToolbar.simple(
        configurations: QuillSimpleToolbarConfigurations(
          controller: _controller,
          showSearchButton: false,
          showFontSize: true,
          multiRowsDisplay: false,
        ),
      ),
    );
  }

  void _showFolderPicker(List<FolderModel> folders) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Folder',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: folders.length,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.folder, color: Colors.blue),
                  title: Text(folders[index].name),
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

  Future<void> _saveNote() async {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }
    final contentJson = jsonEncode(_controller.document.toDelta().toJson());

    final cubit = context.read<NoteCubit>();
    if (widget.existingNote != null) {
      cubit.updateNote(
        widget.existingNote!.copyWith(
          title: titleController.text,
          content: contentJson,
          folderId: selectedFolderId ?? '0',
          tags: tags,
        ),
      );
    } else {
      cubit.addNote(
        title: titleController.text,
        content: contentJson,
        folderId: selectedFolderId ?? '0',
        tags: tags,
      );
    }
    Navigator.pop(context);
  }
}

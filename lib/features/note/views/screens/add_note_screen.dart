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
<<<<<<< Updated upstream
import 'package:pop/features/note/views/widgets/tag_chip.dart';
import 'package:flutter_quill/flutter_quill.dart';
=======
import 'package:pop/core/components/full_screen_image_viewer.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
        final doc = Document.fromJson(
          jsonDecode(widget.existingNote!.content),
        );
        _controller = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        _controller = QuillController.basic();
=======
        final url = await cubit.uploadImage(File(image.path));
        if (!context.mounted) return;
        setState(() {
          imageUrls.add(url);
          isUploading = false;
        });
      } catch (e) {
        if (!context.mounted) return;
        setState(() => isUploading = false);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
        }
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
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
=======
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
>>>>>>> Stashed changes
            }

<<<<<<< Updated upstream
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
=======
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
                    hintText: 'Your thought title...',
                    controller: titleController,
                  ),
                  const SizedBox(height: 48),
                  _buildFieldTitle('CONTENT'),
                  const SizedBox(height: 12),
                  _buildContentEditor(),
                  const SizedBox(height: 12),
                  if (isUploading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.kPrimary)),
                            SizedBox(width: 8),
                            Text('Uploading...', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  _buildImageGrid(),
                  const SizedBox(height: 48),
                  _buildFieldTitle('FOLDER'),
                  const SizedBox(height: 12),
                  _buildFolderSelector(folders),
                  const SizedBox(height: 48),
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
                  const SizedBox(height: 16),
                  _buildAddedTags(),
                  const SizedBox(height: 64),
                  CustomElevatedButton(
                    text: isEditing ? 'UPDATE THOUGHT' : 'SAVE THOUGHT',
                    onPressed: () async {
                      if (titleController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('PLEASE ENTER A TITLE'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.redAccent,
                        ));
                        return;
                      }
                      final contentText = await _controller.getText();
                      if (!context.mounted) return;
                      final cubit = context.read<NoteCubit>();

                      if (isEditing) {
                        await cubit.updateNote(widget.existingNote!.copyWith(
                          title: titleController.text,
                          content: contentText,
                          folderId: selectedFolderId!,
                          tags: tags,
                          images: imageUrls,
                        ));
                      } else {
                        await cubit.addNote(
                          title: titleController.text,
                          content: contentText,
                          folderId: selectedFolderId!,
                          tags: tags,
                          images: imageUrls,
                        );
                      }
                      if (context.mounted) Navigator.pop(context);
                    },
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

  Widget _buildContentEditor() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Column(
          children: [
            HtmlEditor(
              controller: _controller,
              htmlEditorOptions: HtmlEditorOptions(
                hint: 'Start expressing yourself...',
                initialText: widget.existingNote?.content,
                shouldEnsureVisible: true,
              ),
              htmlToolbarOptions: HtmlToolbarOptions(
                toolbarPosition: ToolbarPosition.aboveEditor,
                toolbarType: ToolbarType.nativeScrollable,
                dropdownBackgroundColor: Colors.white,
                buttonColor: AppColors.kPrimary,
                buttonSelectedColor: AppColors.kSecondary,
                defaultToolbarButtons: [
                  const StyleButtons(),
                  const FontButtons(clearAll: false),
                  const ColorButtons(),
                  const ListButtons(),
                  const ParagraphButtons(alignLeft: true, alignCenter: true, alignRight: true),
                  const InsertButtons(video: false, audio: false, table: true),
                ],
                customToolbarButtons: [
                  IconButton(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image_outlined, color: AppColors.kPrimary),
                    tooltip: 'Insert Image',
                  ),
                ],
              ),
              otherOptions: OtherOptions(
                height: 400,
                decoration: BoxDecoration(color: Colors.transparent),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    if (imageUrls.isEmpty) return const SizedBox();
    return Container(
      height: 100,
      margin: const EdgeInsets.only(top: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          final imageUrl = imageUrls[index];
          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenImageViewer(imageUrl: imageUrl, tag: 'add_note_img_$index')));
                },
                child: Hero(
                  tag: 'add_note_img_$index',
                  child: Container(
                    width: 90,
                    height: 90,
                    margin: const EdgeInsets.only(right: 12, top: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                      image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 4,
                top: 0,
                child: GestureDetector(
                  onTap: () => setState(() => imageUrls.removeAt(index)),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                    child: const Icon(Icons.close, color: Colors.white, size: 10),
>>>>>>> Stashed changes
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

<<<<<<< Updated upstream
  Widget _buildHeaderInfo(List<FolderModel> folders) {
    String folderName = 'Select Folder';
=======
  Widget _buildFolderSelector(List<FolderModel> folders) {
    String folderName = 'SELECT FOLDER';
>>>>>>> Stashed changes
    if (selectedFolderId != null && folders.isNotEmpty) {
      final selected = folders.firstWhere((f) => f.id == selectedFolderId, orElse: () => folders.first);
      folderName = selected.name.toUpperCase();
    }

<<<<<<< Updated upstream
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
=======
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
                Icon(Icons.folder_rounded, color: AppColors.kPrimary, size: 24),
                const SizedBox(width: 16),
                Text(folderName, style: AppTextStyles.headlineSm.copyWith(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1)),
              ],
            ),
            const Icon(Icons.arrow_drop_down_rounded, color: Colors.black26),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
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
=======
      backgroundColor: Colors.white.withValues(alpha: 0.95),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('SELECT FOLDER', style: AppTextStyles.labelMd.copyWith(letterSpacing: 2, color: Colors.black26, fontSize: 10, fontWeight: FontWeight.w900)),
              const SizedBox(height: 32),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: folders.length,
                  itemBuilder: (context, index) {
                    final folder = folders[index];
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.kPrimary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.folder_rounded, color: AppColors.kPrimary, size: 20),
                      ),
                      title: Text(folder.name, style: AppTextStyles.headlineSm.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
                      onTap: () {
                        setState(() => selectedFolderId = folder.id);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddedTags() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: tags.map((tag) => TagChip(
        label: tag,
        backgroundColor: Colors.white.withValues(alpha: 0.6),
        textColor: AppColors.kPrimary,
        icon: Icons.close_rounded,
        onTap: () => setState(() => tags.remove(tag)),
      )).toList(),
    );
>>>>>>> Stashed changes
  }
}

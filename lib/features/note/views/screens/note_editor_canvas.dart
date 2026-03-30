import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';
import 'package:pop/features/note/view_models/cubit/note_cubit.dart';
import 'dart:convert';

class NoteEditorCanvas extends StatefulWidget {
  final dynamic initialContent;
  const NoteEditorCanvas({super.key, this.initialContent});

  @override
  State<NoteEditorCanvas> createState() => _NoteEditorCanvasState();
}

class _NoteEditorCanvasState extends State<NoteEditorCanvas> {
  late QuillController _controller;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    if (widget.initialContent != null) {
      try {
        var content = widget.initialContent;
        if (content is String && content.isNotEmpty) {
          content = jsonDecode(content);
        }
        _controller = QuillController(
            document: Document.fromJson(content),
            selection: const TextSelection.collapsed(offset: 0));
      } catch (e) {
        _controller = QuillController.basic();
      }
    } else {
      _controller = QuillController.basic();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onImagePickCallback() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      try {
        final cubit = context.read<NoteCubit>();
        final imageUrl = await cubit.uploadImage(File(image.path));
        
        final index = _controller.selection.baseOffset;
        _controller.replaceSelection(BlockEmbed.image(imageUrl));
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add image: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: AppColors.kPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "DESIGN PAPER",
            style: AppTextStyles.headlineLg.copyWith(fontSize: 16, letterSpacing: 3, fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton(
                onPressed: () {
                  final jsonContent = jsonEncode(_controller.document.toDelta().toJson());
                  Navigator.pop(context, jsonContent);
                },
                child: Text(
                  "DONE",
                  style: AppTextStyles.labelMd.copyWith(color: AppColors.kPrimary, fontWeight: FontWeight.w900, letterSpacing: 1),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            _buildToolbar(),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 40),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: QuillEditor.basic(
                  controller: _controller,
                  config: const QuillEditorConfig(
                    placeholder: 'The floor is yours...',
                    scrollable: true,
                    expands: true,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: QuillSimpleToolbar(
          controller: _controller,
          config: QuillSimpleToolbarConfig(
            showFontFamily: false,
            showSubscript: false,
            showSuperscript: false,
            showSmallButton: false,
            showListCheck: true,
            showDirection: false,
            multiRowsDisplay: false,
            customButtons: [
              QuillToolbarCustomButtonOptions(
                icon: const Icon(Icons.image_outlined, color: AppColors.kPrimary),
                tooltip: 'Insert Image',
                onPressed: _onImagePickCallback,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

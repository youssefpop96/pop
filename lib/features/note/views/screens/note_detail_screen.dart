import 'dart:convert';
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
import 'package:pop/core/components/full_screen_image_viewer.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class NoteDetailScreen extends StatefulWidget {
  final NoteModel note;
  const NoteDetailScreen({super.key, required this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  bool isAddingImage = false;
  late quill.QuillController _quillController;

  @override
  void initState() {
    super.initState();
    _initQuillController(widget.note.content);
  }

  void _initQuillController(String content) {
    if (content.isNotEmpty) {
      try {
        final doc = quill.Document.fromJson(jsonDecode(content));
        _quillController = quill.QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
          readOnly: true,
        );
      } catch (e) {
        // Fallback for non-JSON content
        _quillController = quill.QuillController(
          document: quill.Document()..insert(0, content),
          selection: const TextSelection.collapsed(offset: 0),
          readOnly: true,
        );
      }
    } else {
      _quillController = quill.QuillController.basic(readOnly: true);
    }
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteCubit, NoteState>(
      builder: (context, state) {
        NoteModel currentNote = widget.note;
        if (state is NoteSuccess) {
          final updatedNote = state.recentNotes.firstWhere(
            (n) => n.id == widget.note.id,
            orElse: () => widget.note,
          );
          if (updatedNote.content != currentNote.content) {
            _initQuillController(updatedNote.content);
          }
          currentNote = updatedNote;
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
                  _buildNoteContent(currentNote.title),
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
          icon: const Icon(
            Icons.picture_as_pdf_outlined,
            color: AppColors.kPrimaryColor,
          ),
          onPressed: () => _exportToPdf(context, currentNote),
        ),
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: AppColors.kPrimaryColor),
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

  Widget _buildNoteContent(String title) {
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
        quill.QuillEditor.basic(
          controller: _quillController,
          configurations: const quill.QuillEditorConfigurations(
            readOnly: true,
            expands: false,
            padding: EdgeInsets.zero,
            showCursor: false,
          ),
        ),
      ],
    );
  }

  Future<void> _exportToPdf(BuildContext context, NoteModel note) async {
    try {
      final doc = pw.Document();

      // Extract plain text for simple PDF version
      // In a real app, you might want to map Quill attributes to PDF widgets
      final plainText = _quillController.document.toPlainText();

      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                note.title,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Paragraph(
              text: plainText,
              style: const pw.TextStyle(fontSize: 14),
            ),
          ],
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to generate PDF: $e')));
      }
    }
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
              if (currentNote.images.isEmpty && !isAddingImage)
                const Text(
                  'No photos added yet',
                  style: TextStyle(color: Colors.black38),
                ),
              ...currentNote.images.asMap().entries.map((entry) {
                final int idx = entry.key;
                final String img = entry.value;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImageViewer(
                          imageUrl: img,
                          tag: 'note_${currentNote.id}_img_$idx',
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'note_${currentNote.id}_img_$idx',
                    child: Container(
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
                );
              }),
              if (isAddingImage)
                Container(
                  height: 70,
                  width: 70,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              GestureDetector(
                onTap: isAddingImage ? null : () => _onAddImage(currentNote),
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

  Future<void> _onAddImage(NoteModel currentNote) async {
    final cubit = context.read<NoteCubit>();
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (!mounted) return;
      setState(() => isAddingImage = true);
      try {
        final url = await cubit.uploadImage(File(image.path));
        final updatedImages = List<String>.from(currentNote.images)..add(url);
        await cubit.updateNote(currentNote.copyWith(images: updatedImages));
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Image added!')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to add image: $e')));
        }
      } finally {
        if (mounted) {
          setState(() => isAddingImage = false);
        }
      }
    }
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
        children: const [
          Icon(Icons.home_outlined, color: Colors.black54),
          Icon(Icons.star_border, color: Colors.black54),
          Icon(Icons.shopping_bag_outlined, color: Colors.black54),
          Icon(Icons.folder_outlined, color: Colors.black54),
        ],
      ),
    );
  }
}

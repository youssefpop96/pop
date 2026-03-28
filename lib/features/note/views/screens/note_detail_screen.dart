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
import 'package:flutter_quill/flutter_quill.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart' as htw;
import 'package:pop/core/utilities/styles/app_text_styles.dart';

class NoteDetailScreen extends StatefulWidget {
  final NoteModel note;
  const NoteDetailScreen({super.key, required this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  bool isAddingImage = false;
  late QuillController _quillController;

  @override
  void initState() {
    super.initState();
    _initQuillController(widget.note.content);
  }

  void _initQuillController(String content) {
    if (content.isNotEmpty) {
      try {
        final doc = Document.fromJson(jsonDecode(content));
        _quillController = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        // Fallback for non-JSON content
        _quillController = QuillController(
          document: Document()..insert(0, content),
          selection: const TextSelection.collapsed(offset: 0),
        );
      }
    } else {
      _quillController = QuillController.basic();
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
            appBar: _buildAppBar(context, currentNote),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  _buildDateHeader(currentNote.createdAt),
<<<<<<< Updated upstream
                  const SizedBox(height: 20),
                  _buildNoteContent(currentNote.title),
                  const SizedBox(height: 24),
=======
                  const SizedBox(height: 32),
                  _buildNoteContent(currentNote.title, currentNote.content),
                  const SizedBox(height: 64),
>>>>>>> Stashed changes
                  _buildPhotosSection(context, currentNote),
                  const SizedBox(height: 48),
                  _buildTagsSection(currentNote.tags),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, NoteModel currentNote) {
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
        'THOUGHT',
        style: AppTextStyles.headlineLg.copyWith(fontSize: 18, letterSpacing: 4, fontWeight: FontWeight.w900),
      ),
      centerTitle: true,
      actions: [
        IconButton(
<<<<<<< Updated upstream
          icon: const Icon(
            Icons.picture_as_pdf_outlined,
            color: AppColors.kPrimaryColor,
          ),
=======
          icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.black45, size: 22),
>>>>>>> Stashed changes
          onPressed: () => _exportToPdf(context, currentNote),
        ),
        IconButton(
          icon: const Icon(Icons.edit_rounded, color: Colors.black45, size: 22),
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
          icon: const Icon(Icons.delete_rounded, color: Colors.redAccent, size: 22),
          onPressed: () => _showDeleteDialog(context, currentNote),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, NoteModel currentNote) {
    showDialog(
      context: context,
      builder: (diagContext) => AlertDialog(
<<<<<<< Updated upstream
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(diagContext),
            child: const Text('Cancel'),
=======
        backgroundColor: Colors.white.withValues(alpha: 0.95),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
        title: Text('DELETE THOUGHT', style: AppTextStyles.headlineSm.copyWith(letterSpacing: 2, fontSize: 16)),
        content: Text('ARE YOU SURE YOU WANT TO DELETE THIS THOUGHT? IT CANNOT BE UNDONE.', style: AppTextStyles.labelMd.copyWith(color: Colors.black45, fontSize: 12, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(diagContext),
            child: Text('CANCEL', style: AppTextStyles.labelMd.copyWith(color: Colors.black45, fontWeight: FontWeight.w900, letterSpacing: 1)),
>>>>>>> Stashed changes
          ),
          TextButton(
            onPressed: () {
              context.read<NoteCubit>().deleteNote(currentNote.id);
              Navigator.pop(diagContext);
              Navigator.pop(context);
<<<<<<< Updated upstream
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Note deleted')));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
=======
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('THOUGHT DELETED'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppColors.kPrimary,
              ));
            },
            child: Text('DELETE', style: AppTextStyles.labelMd.copyWith(color: Colors.redAccent, fontWeight: FontWeight.w900, letterSpacing: 1)),
>>>>>>> Stashed changes
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(DateTime date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.kPrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.kPrimary.withValues(alpha: 0.2), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_month_rounded, size: 16, color: AppColors.kPrimary),
          const SizedBox(width: 12),
          Text(
            '${date.day}/${date.month}/${date.year}',
            style: AppTextStyles.labelMd.copyWith(color: AppColors.kPrimary, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteContent(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.headlineLg.copyWith(fontSize: 36, height: 1.2),
        ),
<<<<<<< Updated upstream
        const SizedBox(height: 12),
        QuillEditor.basic(
          controller: _quillController,
          configurations: const QuillEditorConfigurations(
            readOnly: true,
            expands: false,
            padding: EdgeInsets.zero,
            showCursor: false,
          ),
=======
        const SizedBox(height: 32),
        Html(
          data: content,
          style: {
            "body": Style(
              fontSize: FontSize(18),
              color: Colors.black87,
              margin: Margins.zero,
              padding: HtmlPaddings.zero,
              fontFamily: 'Outfit',
              lineHeight: LineHeight.em(1.6),
            ),
          },
>>>>>>> Stashed changes
        ),
      ],
    );
  }

  Future<void> _exportToPdf(BuildContext context, NoteModel note) async {
    try {
      final doc = pw.Document();
<<<<<<< Updated upstream

      // Extract plain text for simple PDF version
      // In a real app, you might want to map Quill attributes to PDF widgets
      final plainText = _quillController.document.toPlainText();

=======
      final widgets = await htw.HTMLToPdf().convert(note.content);
      
>>>>>>> Stashed changes
      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
<<<<<<< Updated upstream
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
=======
            pw.Header(level: 0, child: pw.Text(note.title, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold))),
            pw.Divider(),
            ...widgets,
>>>>>>> Stashed changes
          ],
        ),
      );

      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
    } catch (e) {
      if (context.mounted) {
<<<<<<< Updated upstream
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to generate PDF: $e')));
=======
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to generate PDF: $e')));
>>>>>>> Stashed changes
      }
    }
  }

  Widget _buildPhotosSection(BuildContext context, NoteModel currentNote) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PHOTOS', style: AppTextStyles.labelMd.copyWith(letterSpacing: 2, color: Colors.black26, fontSize: 10, fontWeight: FontWeight.w900)),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              if (currentNote.images.isEmpty && !isAddingImage)
                Text('NO PHOTOS ATTACHED', style: AppTextStyles.labelMd.copyWith(color: Colors.black26, fontSize: 10, letterSpacing: 1)),
              ...currentNote.images.asMap().entries.map((entry) {
                final int idx = entry.key;
                final String img = entry.value;
                return GestureDetector(
                  onTap: () {
<<<<<<< Updated upstream
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImageViewer(
                          imageUrl: img,
                          tag: 'note_${currentNote.id}_img_$idx',
                        ),
                      ),
                    );
=======
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenImageViewer(imageUrl: img, tag: 'note_${currentNote.id}_img_$idx')));
>>>>>>> Stashed changes
                  },
                  child: Hero(
                    tag: 'note_${currentNote.id}_img_$idx',
                    child: Container(
                      height: 120,
                      width: 120,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 15, offset: const Offset(0, 8))],
                        image: DecorationImage(image: NetworkImage(img), fit: BoxFit.cover),
                      ),
                    ),
                  ),
                );
              }),
              if (isAddingImage)
                Container(
                  height: 120,
                  width: 120,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(28)),
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.kPrimary)),
                ),
              GestureDetector(
                onTap: isAddingImage ? null : () => _onAddImage(currentNote),
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5, style: BorderStyle.solid),
                  ),
                  child: Icon(Icons.add_a_photo_rounded, color: AppColors.kPrimary, size: 32),
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
<<<<<<< Updated upstream
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
=======
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add image: $e')));
>>>>>>> Stashed changes
      } finally {
        if (mounted) setState(() => isAddingImage = false);
      }
    }
  }

  Widget _buildTagsSection(List<String> tags) {
    if (tags.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('TAGS', style: AppTextStyles.labelMd.copyWith(letterSpacing: 2, color: Colors.black26, fontSize: 10, fontWeight: FontWeight.w900)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: tags.map((tag) => TagChip(
            label: tag,
            backgroundColor: Colors.white.withValues(alpha: 0.6),
            textColor: AppColors.kPrimary,
          )).toList(),
        ),
      ],
    );
  }
}

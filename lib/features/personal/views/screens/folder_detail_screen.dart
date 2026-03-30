import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pop/core/models/folder_model.dart';
import 'package:pop/core/models/note_model.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/features/personal/views/widgets/note_card.dart';
import 'package:pop/features/note/views/screens/add_note_screen.dart';
import 'package:pop/features/note/views/screens/note_detail_screen.dart';
import 'package:pop/features/note/view_models/cubit/note_cubit.dart';
import 'package:pop/features/note/view_models/cubit/note_state.dart';
import 'package:pop/features/home/views/screens/add_folder_screen.dart';

class FolderDetailScreen extends StatefulWidget {
  final FolderModel folder;
  const FolderDetailScreen({super.key, required this.folder});

  @override
  State<FolderDetailScreen> createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NoteCubit>().fetchFolderNotes(widget.folder.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteCubit, NoteState>(
      builder: (context, state) {
        // Find the latest folder data from state if available
        FolderModel currentFolder = widget.folder;
        List<NoteModel> notes = [];
        
        if (state is NoteSuccess) {
          try {
            currentFolder = state.folders.firstWhere((f) => f.id == widget.folder.id);
          } catch (_) {}
          notes = state.folderNotes ?? [];
        }

        final colorIndex = currentFolder.colorIndex % AppColors.kFolderGradients.length;
        final gradient = AppColors.kFolderGradients[colorIndex];
        final icon = AppColors.kFolderIcons[colorIndex];

        return Scaffold(
          backgroundColor: AppColors.kLightGreyColor,
          appBar: _buildAppBar(context, gradient.first, currentFolder),
          body: state is NoteLoading 
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildHeaderCard(gradient, icon, currentFolder, notes.length),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      child: notes.isEmpty
                          ? const Center(child: Text('No notes in this folder.'))
                          : Column(
                              children: notes
                                  .map(
                                    (note) => NoteCard(
                                      title: note.title,
                                      subtitle: note.content,
                                      timeText: '${note.createdAt.day}/${note.createdAt.month}',
                                      indicatorColor: gradient.first,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => NoteDetailScreen(note: note),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),
                  ],
                ),
              ),
          floatingActionButton: _buildFloatingAddButton(context, gradient.first, currentFolder),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, Color themeColor, FolderModel folder) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        folder.name,
        style: TextStyle(
          color: themeColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onSelected: (value) {
            if (value == 'edit') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddFolderScreen(folderToEdit: folder),
                ),
              );
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit Folder'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderCard(List<Color> gradient, IconData icon, FolderModel folder, int count) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      folder.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$count Notes',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNoteScreen(initialFolderId: folder.id),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: gradient.first),
                  const SizedBox(width: 8),
                  const Text(
                    'Add New Note',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingAddButton(BuildContext context, Color themeColor, FolderModel folder) {
    return Container(
      decoration: BoxDecoration(
        color: themeColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: themeColor.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.add, color: Colors.white, size: 28),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNoteScreen(initialFolderId: folder.id),
            ),
          );
        },
      ),
    );
  }
}

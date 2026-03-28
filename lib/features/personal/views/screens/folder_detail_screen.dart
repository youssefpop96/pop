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
import 'package:pop/core/utilities/styles/app_text_styles.dart';

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
        appBar: _buildAppBar(context),
        body: BlocBuilder<NoteCubit, NoteState>(
          builder: (context, state) {
            if (state is NoteLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.kPrimary));
            }

            List<NoteModel> notes = [];
            if (state is NoteSuccess) {
              notes = state.folderNotes ?? [];
            }

            return RefreshIndicator(
              onRefresh: () => context.read<NoteCubit>().fetchFolderNotes(widget.folder.id),
              color: AppColors.kPrimary,
              backgroundColor: Colors.white,
              strokeWidth: 2.5,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                slivers: [
                  SliverToBoxAdapter(child: _buildHeaderCard(notes.length)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    sliver: notes.isEmpty
                        ? SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: Text(
                                'THIS COLLECTION IS CURRENTLY EMPTY.',
                                style: AppTextStyles.labelMd.copyWith(color: Colors.black26, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.w900),
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final note = notes[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: NoteCard(
                                    title: note.title,
                                    subtitle: note.content,
                                    timeText: '${note.createdAt.day}/${note.createdAt.month}',
                                    indicatorColor: AppColors.kPrimary,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => NoteDetailScreen(note: note)),
                                      );
                                    },
                                  ),
                                );
                              },
                              childCount: notes.length,
                            ),
                          ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 160)),
                ],
              ),
            );
          },
        ),
        floatingActionButton: _buildFloatingAddButton(context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
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
        'COLLECTION',
        style: AppTextStyles.headlineLg.copyWith(fontSize: 18, letterSpacing: 4, fontWeight: FontWeight.w900),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.more_horiz_rounded, color: Colors.black45, size: 24),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildHeaderCard(int count) {
    return Container(
      margin: const EdgeInsets.fromLTRB(28, 24, 28, 16),
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.kPrimary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.kPrimary.withValues(alpha: 0.2), width: 1.5),
                ),
                child: const Icon(Icons.folder_rounded, color: AppColors.kPrimary, size: 36),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.kPrimary.withValues(alpha: 0.1), width: 1.5),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Text(
                  '$count ITEMS',
                  style: AppTextStyles.labelMd.copyWith(color: AppColors.kPrimary, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            widget.folder.name.toUpperCase(),
            style: AppTextStyles.headlineLg.copyWith(letterSpacing: 1, fontSize: 24, height: 1.2),
          ),
          const SizedBox(height: 12),
          Text(
            'Keep your thoughts organized and accessible in this collection.',
            style: AppTextStyles.labelMd.copyWith(color: Colors.black45, fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingAddButton(BuildContext context) {
    return Container(
      height: 72,
      width: 72,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.kPrimary, Color(0xFF5C7CFA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.kPrimary.withValues(alpha: 0.4),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(36),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNoteScreen(initialFolderId: widget.folder.id)),
            );
          },
          child: const Center(
            child: Icon(Icons.add_rounded, color: Colors.white, size: 36),
          ),
        ),
      ),
    );
  }
}

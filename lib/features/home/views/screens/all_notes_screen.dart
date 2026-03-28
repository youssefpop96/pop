import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';
import 'package:pop/features/note/view_models/cubit/note_cubit.dart';
import 'package:pop/features/note/view_models/cubit/note_state.dart';
import 'package:pop/features/personal/views/widgets/note_card.dart';
import 'package:pop/features/note/views/screens/note_detail_screen.dart';

class AllNotesScreen extends StatelessWidget {
  const AllNotesScreen({super.key});

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
          leading: Center(
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.kPrimary, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Text(
            'ALL NOTES',
            style: AppTextStyles.headlineLg.copyWith(fontSize: 18, letterSpacing: 4, fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<NoteCubit, NoteState>(
          builder: (context, state) {
            if (state is NoteLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is NoteSuccess) {
              final notes = state.recentNotes;
              if (notes.isEmpty) {
                return Center(
                  child: Text(
                    'NO NOTES FOUND.',
                    style: AppTextStyles.labelMd.copyWith(color: Colors.black26, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.w900),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () => context.read<NoteCubit>().fetchHomeData(),
                color: AppColors.kPrimary,
                backgroundColor: Colors.white,
                strokeWidth: 2.5,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      sliver: SliverList(
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
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';
import 'package:pop/features/note/view_models/cubit/note_cubit.dart';
import 'package:pop/features/note/view_models/cubit/note_state.dart';
import 'package:pop/features/home/views/widgets/folder_card.dart';
import 'package:pop/features/personal/views/screens/folder_detail_screen.dart';
import 'package:pop/features/home/views/screens/add_folder_screen.dart';

class AllFoldersScreen extends StatelessWidget {
  const AllFoldersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<List<Color>> gradientPool = [
      AppColors.kGradientBlue,
      AppColors.kGradientGreen,
      AppColors.kGradientPurple,
      AppColors.kGradientOrange,
      AppColors.kGradientPink,
      AppColors.kGradientTeal,
    ];

    final List<IconData> iconPool = [
      Icons.folder,
      Icons.business_center,
      Icons.videocam,
      Icons.home,
      Icons.description,
      Icons.stars,
    ];

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
            'ALL FOLDERS',
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
              final folders = state.folders;
              final notes = state.recentNotes;

              if (folders.isEmpty) {
                return Center(
                  child: Text(
                    'NO FOLDERS FOUND.',
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
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final folder = folders[index];
                            final count = notes.where((note) => note.folderId == folder.id).length;
                            final countLabel = count == 1 ? '1 Note' : '$count Notes';

                            final colorIndex = folder.colorIndex % gradientPool.length;
                            int iconIndex = 0;
                            if (folder.iconName != null && folder.iconName!.startsWith('icon_')) {
                              iconIndex = int.tryParse(folder.iconName!.split('_')[1]) ?? 0;
                              iconIndex = iconIndex % iconPool.length;
                            } else {
                              iconIndex = folder.colorIndex % iconPool.length;
                            }

                            return FolderCard(
                              title: folder.name,
                              notesCount: countLabel,
                              gradientColors: gradientPool[colorIndex],
                              icon: iconPool[iconIndex],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => FolderDetailScreen(folder: folder)),
                                );
                              },
                            );
                          },
                          childCount: folders.length,
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
        floatingActionButton: Container(
          width: 72,
          height: 72,
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
                  MaterialPageRoute(builder: (context) => const AddFolderScreen()),
                );
              },
              child: const Center(
                child: Icon(Icons.create_new_folder_rounded, color: Colors.white, size: 30),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

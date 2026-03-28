import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';
import 'package:pop/features/note/view_models/cubit/note_cubit.dart';
import 'package:pop/features/note/view_models/cubit/note_state.dart';
import 'package:pop/features/note/views/screens/add_note_screen.dart';
import 'package:pop/features/profile/views/screens/profile_screen.dart';
import 'package:pop/features/home/views/widgets/home_folders_section.dart';
import 'package:pop/features/home/views/widgets/home_recent_notes_section.dart';
import 'package:pop/core/models/note_model.dart';
import 'package:pop/features/home/views/screens/all_notes_screen.dart';
import 'package:pop/features/home/views/screens/all_folders_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = '#ALL';

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
        appBar: _buildLuminousAppBar(context),
        body: BlocBuilder<NoteCubit, NoteState>(
          builder: (context, state) {
            if (state is NoteLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NoteFailure) {
              return Center(
                child: Text(
                  'ERROR: ${state.errMessage.toUpperCase()}',
                  style: AppTextStyles.labelMd.copyWith(color: Colors.redAccent, fontWeight: FontWeight.w900),
                ),
              );
            } else if (state is NoteSuccess) {
              return _buildLuminousBody(context, state);
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: _buildLuminousFAB(context),
      ),
    );
  }

  AppBar _buildLuminousAppBar(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final String? avatarUrl = user?.userMetadata?['avatar_url'];

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: const SizedBox(width: 40),
      title: Text('POP NOTES', style: AppTextStyles.headlineLg.copyWith(fontSize: 18, letterSpacing: 4, fontWeight: FontWeight.w900)),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.kPrimary.withValues(alpha: 0.2), width: 1.5),
              ),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.kPrimary.withValues(alpha: 0.1),
                backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                child: avatarUrl == null ? const Icon(Icons.person_rounded, color: AppColors.kPrimary, size: 16) : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLuminousBody(BuildContext context, NoteSuccess state) {
    Set<String> uniqueTags = {'#ALL'};
    
    // Add all existing tags
    for (var note in state.recentNotes) {
      for (var tag in note.tags) {
        if (tag.trim().isNotEmpty) {
          uniqueTags.add('#${tag.trim().toUpperCase()}');
        }
      }
    }
    
    // Add all folder names as tags to always have meaningful filters
    for (var folder in state.folders) {
      if (folder.name.trim().isNotEmpty) {
         uniqueTags.add('#${folder.name.trim().toUpperCase()}');
      }
    }
    
    final categories = uniqueTags.toList();

    List<NoteModel> filteredNotes = state.recentNotes;
    if (selectedCategory != '#ALL') {
      final tagFilter = selectedCategory.replaceAll('#', '').toLowerCase();
      filteredNotes = state.recentNotes.where((note) {
        return note.tags.any((t) => t.toLowerCase() == tagFilter) || 
               state.folders.any((f) => f.id == note.folderId && f.name.toLowerCase() == tagFilter);
      }).toList();
    }

    return RefreshIndicator(
      onRefresh: () => context.read<NoteCubit>().fetchHomeData(),
      color: AppColors.kPrimary,
      backgroundColor: Colors.white,
      strokeWidth: 2.5,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          _buildLuminousSearchBar(),
          const SizedBox(height: 40),
          _buildCategoryChips(categories),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('FOLDERS', style: AppTextStyles.headlineSm.copyWith(letterSpacing: 2, fontWeight: FontWeight.w900, fontSize: 13, color: Colors.black26)),
              GestureDetector(
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const AllFoldersScreen()));
                },
                child: Text('VIEW ALL', style: AppTextStyles.labelMd.copyWith(color: AppColors.kPrimary, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          HomeFoldersSection(folders: state.folders, notes: state.recentNotes),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('RECENT NOTES', style: AppTextStyles.headlineSm.copyWith(letterSpacing: 2, fontWeight: FontWeight.w900, fontSize: 13, color: Colors.black26)),
              GestureDetector(
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const AllNotesScreen()));
                },
                child: Text('VIEW ALL', style: AppTextStyles.labelMd.copyWith(color: AppColors.kPrimary, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          HomeRecentNotesSection(notes: filteredNotes.take(5).toList(), folders: state.folders),
          const SizedBox(height: 160),
        ],
      ),
    ),
  );
}

  Widget _buildLuminousSearchBar() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: Colors.black26, size: 24),
          const SizedBox(width: 16),
          Text('FIND YOUR THOUGHTS...', style: AppTextStyles.labelMd.copyWith(color: Colors.black26, fontSize: 13, letterSpacing: 1, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(List<String> categories) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: categories.map((cat) {
          final isSelected = cat == selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = cat),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.kPrimary : Colors.white.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected ? AppColors.kPrimary : Colors.white.withValues(alpha: 0.6),
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [BoxShadow(color: AppColors.kPrimary.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 8))]
                    : null,
              ),
              child: Text(
                cat,
                style: AppTextStyles.labelMd.copyWith(
                  color: isSelected ? Colors.white : Colors.black45,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLuminousFAB(BuildContext context) {
    return Container(
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
          borderRadius: BorderRadius.circular(25),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNoteScreen())),
          child: const Center(
            child: Icon(Icons.add_rounded, color: Colors.white, size: 25),
          ),
        ),
      ),
    );
  }
}


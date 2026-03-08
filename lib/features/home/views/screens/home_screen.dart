import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/features/home/views/widgets/custom_search_bar.dart';
import 'package:pop/features/home/views/widgets/home_folders_section.dart';
import 'package:pop/features/home/views/widgets/home_recent_notes_section.dart';
import 'package:pop/features/note/view_models/cubit/note_cubit.dart';
import 'package:pop/features/note/view_models/cubit/note_state.dart';
import 'package:pop/features/note/views/screens/add_note_screen.dart';
import 'package:pop/features/splash/views/screens/splash_screen.dart';
import 'package:pop/features/home/views/screens/add_folder_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: BlocBuilder<NoteCubit, NoteState>(
        builder: (context, state) {
          if (state is NoteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NoteFailure) {
            return Center(child: Text('Error: ${state.errMessage}'));
          } else if (state is NoteSuccess) {
            return _buildHomeBody(context, state);
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: _buildFloatingAddButton(context),
    );
  }

  Widget _buildHomeBody(BuildContext context, NoteSuccess state) {
    return RefreshIndicator(
      onRefresh: () => context.read<NoteCubit>().fetchHomeData(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomSearchBar(),
            const SizedBox(height: 20),
            _buildCreateFolderButton(context),
            const SizedBox(height: 24),
            HomeFoldersSection(folders: state.folders),
            const SizedBox(height: 32),
            _buildRecentNotesTitle(),
            const SizedBox(height: 16),
            HomeRecentNotesSection(notes: state.recentNotes),
            const SizedBox(height: 100), // spacing for FAB
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.sort, color: Colors.black),
        onPressed: () {},
      ),
      title: const Text(
        'My Folders',
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.black54),
          onPressed: () async {
            await Supabase.instance.client.auth.signOut();
            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SplashScreen()),
                (route) => false,
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildCreateFolderButton(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => _showCreateFolderDialog(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: AppColors.kGradientBlue.first),
              const SizedBox(width: 8),
              const Text(
                'Create New Folder',
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
    );
  }

  void _showCreateFolderDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddFolderScreen()),
    );
  }

  Widget _buildRecentNotesTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recent Notes',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: const [
            Text(
              'View All',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          ],
        ),
      ],
    );
  }

  Widget _buildFloatingAddButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0061FF),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0061FF).withValues(alpha: 0.4),
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
            MaterialPageRoute(builder: (context) => const AddNoteScreen()),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';
import 'package:pop/features/home/views/widgets/custom_search_bar.dart';
import 'package:pop/features/home/views/widgets/home_folders_section.dart';
import 'package:pop/features/home/views/widgets/home_recent_notes_section.dart';
import 'package:pop/features/note/view_models/cubit/note_cubit.dart';
import 'package:pop/features/note/view_models/cubit/note_state.dart';
import 'package:pop/features/note/views/screens/add_note_screen.dart';
import 'package:pop/features/profile/views/screens/profile_screen.dart';
import 'package:pop/features/home/views/screens/all_folders_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedTag;
  int _bottomNavIndex = 0;

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
        body: IndexedStack(
          index: _bottomNavIndex,
          children: [
            _buildLibraryTab(),
            const Center(child: Text('Drafts Screen (Coming Soon)')),
            const Center(child: Text('Settings Screen (Coming Soon)')),
          ],
        ),
        floatingActionButton: _buildFloatingAddButton(context),
        bottomNavigationBar: _buildBottomNav(context),
      ),
    );
  }

  Widget _buildLibraryTab() {
    return BlocBuilder<NoteCubit, NoteState>(
      builder: (context, state) {
        if (state is NoteLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.kPrimary));
        } else if (state is NoteFailure) {
          return _buildErrorState(context, state.errMessage);
        } else if (state is NoteSuccess) {
          return _buildHomeBody(context, state);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildHomeBody(BuildContext context, NoteSuccess state) {
    // 1. استخراج التاجز ديناميكياً من الملاحظات
    final dynamicTags = state.recentNotes
        .expand((note) => note.tags)
        .map((tag) => tag.startsWith('#') ? tag : '#$tag')
        .toSet()
        .toList();

    // 2. تصفية الملاحظات بناءً على التاج المختار
    final filteredNotes = _selectedTag == null
        ? state.recentNotes
        : state.recentNotes.where((note) {
            final cleanSelected = _selectedTag!.replaceAll('#', '').toLowerCase();
            return note.tags.any((tag) => tag.toLowerCase() == cleanSelected);
          }).toList();

    return RefreshIndicator(
      onRefresh: () => context.read<NoteCubit>().fetchHomeData(),
      color: AppColors.kPrimary,
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const CustomSearchBar(),
            const SizedBox(height: 24),
            _buildQuickFilters(dynamicTags), // تمرير التاجز الديناميكية
            const SizedBox(height: 32),
            _buildSectionHeader('Folders', onAction: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AllFoldersScreen()));
            }),
            const SizedBox(height: 16),
            HomeFoldersSection(
              folders: state.folders,
              notes: state.recentNotes,
            ),
            const SizedBox(height: 32),
            _buildFeaturedCard(),
            const SizedBox(height: 40),
            _buildSectionHeader('Recent Notes', showAction: false),
            const SizedBox(height: 16),
            HomeRecentNotesSection(
              notes: filteredNotes,
              folders: state.folders,
            ),
            const SizedBox(height: 120), 
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 80, color: AppColors.kPrimary.withValues(alpha: 0.3)),
            const SizedBox(height: 24),
            Text(
              'Connection Error',
              style: AppTextStyles.headlineSm.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            Text(
              'Please check your internet connection and try again.',
              textAlign: TextAlign.center,
              style: AppTextStyles.labelMd.copyWith(color: Colors.black38),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.read<NoteCubit>().fetchHomeData(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              ),
              child: const Text('RETRY'),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final profileUrl = user?.userMetadata?['avatar_url'];
    final fullName = user?.userMetadata?['full_name'] ?? 'User';

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: AppColors.kPrimary, size: 28),
        onPressed: () {},
      ),
      title: Text(
        'Luminous Notes',
        style: AppTextStyles.headlineSm.copyWith(
          color: AppColors.kOnSurface,
          fontWeight: FontWeight.w900,
          fontSize: 20,
        ),
      ),
      centerTitle: false,
      actions: [
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.kPrimary.withValues(alpha: 0.1),
              backgroundImage: profileUrl != null ? NetworkImage(profileUrl) : null,
              child: profileUrl == null 
                ? Text(
                    fullName[0].toUpperCase(), 
                    style: const TextStyle(color: AppColors.kPrimary, fontWeight: FontWeight.bold, fontSize: 14)
                  )
                : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickFilters(List<String> tags) {
    if (tags.isEmpty) return const SizedBox();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: tags.map((tag) {
          bool isSelected = _selectedTag == tag;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTag = isSelected ? null : tag;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.kPrimary : Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.white.withValues(alpha: 0.8),
                  width: 1.5,
                ),
                boxShadow: isSelected ? [BoxShadow(color: AppColors.kPrimary.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))] : [],
              ),
              child: Text(
                tag,
                style: AppTextStyles.labelMd.copyWith(
                  color: isSelected ? Colors.white : AppColors.kPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onAction, bool showAction = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.headlineSm.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppColors.kOnSurface,
          ),
        ),
        if (showAction)
          GestureDetector(
            onTap: onAction,
            child: Text(
              'VIEW ALL',
              style: AppTextStyles.labelMd.copyWith(
                color: AppColors.kSecondary,
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFeaturedCard() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00E3FD), Color(0xFF9500C8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9500C8).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.restaurant_menu_rounded,
              size: 140,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.restaurant_menu_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recipes',
                        style: AppTextStyles.headlineSm.copyWith(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Curated collection',
                        style: AppTextStyles.labelMd.copyWith(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingAddButton(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.kPrimary, AppColors.kPrimaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.kPrimary.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNoteScreen())),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.folder_rounded, 'LIBRARY'),
          _buildNavItem(1, Icons.edit_document, 'DRAFTS'),
          _buildNavItem(2, Icons.settings_rounded, 'SETTINGS'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isActive = _bottomNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _bottomNavIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? AppColors.kPrimary : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.white : Colors.black26,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelMd.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isActive ? AppColors.kPrimary : Colors.black26,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/features/home/views/screens/home_screen.dart';
import 'package:pop/features/profile/views/screens/profile_screen.dart';

import 'package:pop/core/utilities/styles/app_text_styles.dart';

class LuminousMainScreen extends StatefulWidget {
  const LuminousMainScreen({super.key});

  @override
  State<LuminousMainScreen> createState() => _LuminousMainScreenState();
}

class _LuminousMainScreenState extends State<LuminousMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(child: Text('DRAFTS COMING SOON')),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(28, 0, 28, 12),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.grid_view_rounded, 'EXPLORE'),
            _buildNavItem(1, Icons.edit_note_rounded, 'DRAFTS'),
            _buildNavItem(2, Icons.person_rounded, 'PROFILE'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.kPrimary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(28),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.kPrimary : Colors.black26,
              size: 24,
            ),
            const SizedBox(height: 4),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isSelected ? 1.0 : 0.0,
              child: Text(
                label,
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.kPrimary,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

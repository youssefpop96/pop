import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/features/splash/views/screens/splash_screen.dart';
import 'package:pop/features/note/view_models/cubit/note_cubit.dart';
import 'package:pop/core/repositories/auth_repository.dart';
import 'package:pop/features/note/view_models/cubit/note_state.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';
import 'package:pop/core/components/custom_text_form_field.dart';
import 'package:pop/core/components/custom_elevated_button.dart';
import 'package:pop/features/profile/views/screens/app_lock_settings_screen.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isUploading = false;

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (image != null) {
      if (!context.mounted) return;
      setState(() => _isUploading = true);

      try {
        final noteCubit = context.read<NoteCubit>();
        final authRepo = context.read<AuthRepository>();
        final imageUrl = await noteCubit.uploadImage(File(image.path));
        await authRepo.updateUserMetadata({'avatar_url': imageUrl});

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile picture updated!')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload: $e')),
          );
        }
      } finally {
        if (context.mounted) {
          setState(() => _isUploading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteCubit, NoteState>(
      builder: (context, noteState) {
        final user = Supabase.instance.client.auth.currentUser;
        final String email = user?.email ?? 'NO EMAIL AVAILABLE';
        final String name = (user?.userMetadata?['full_name'] ?? user?.userMetadata?['name'] ?? 'GUEST USER').toString().toUpperCase();
        final String? avatarUrl = user?.userMetadata?['avatar_url'];

        int notesCount = 0;
        int foldersCount = 0;
        if (noteState is NoteSuccess) {
          notesCount = noteState.recentNotes.length;
          foldersCount = noteState.folders.length;
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
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Center(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.kPrimary, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              title: Text('PROFILE', style: AppTextStyles.headlineLg.copyWith(fontSize: 18, letterSpacing: 4, fontWeight: FontWeight.w900)),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 48),
                  _buildProfileHeader(name, email, avatarUrl),
                  const SizedBox(height: 56),
                  _buildStatsSection(notesCount.toString(), foldersCount.toString()),
                  const SizedBox(height: 56),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('ACCOUNT SETTINGS', style: AppTextStyles.labelMd.copyWith(letterSpacing: 2, color: Colors.black26, fontSize: 10, fontWeight: FontWeight.w900)),
                  ),
                  const SizedBox(height: 24),
                  _buildSettingsItem(
                    icon: Icons.person_outline_rounded,
                    title: 'EDIT NAME',
                    onTap: () => _showEditNameDialog(context, name),
                  ),
                  _buildSettingsItem(
                    icon: Icons.lock_outline_rounded,
                    title: 'CHANGE PASSWORD',
                    onTap: () => _showChangePasswordDialog(context),
                  ),
                  _buildSettingsItem(
                    icon: Icons.fingerprint_rounded,
                    title: 'APP LOCK',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AppLockSettingsScreen()));
                    },
                  ),
                  _buildSettingsItem(
                    icon: Icons.notifications_none_rounded,
                    title: 'NOTIFICATIONS',
                    onTap: () {},
                  ),
                  const SizedBox(height: 48),
                  _buildLogoutButton(context),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditNameDialog(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        title: Text('EDIT NAME', style: AppTextStyles.headlineSm.copyWith(letterSpacing: 2, fontWeight: FontWeight.w900)),
        content: CustomTextFormField(
          hintText: 'Enter your name',
          controller: controller,
        ),
        actionsPadding: const EdgeInsets.all(24),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('CANCEL', style: AppTextStyles.labelMd.copyWith(color: Colors.black38, fontWeight: FontWeight.w900)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomElevatedButton(
                  text: 'SAVE',
                  minimumSize: const Size(0, 48),
                  onPressed: () async {
                    if (controller.text.isNotEmpty) {
                      final authRepo = context.read<AuthRepository>();
                      await authRepo.updateUserMetadata({'full_name': controller.text});
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        title: Text('CHANGE PASSWORD', style: AppTextStyles.headlineSm.copyWith(letterSpacing: 2, fontWeight: FontWeight.w900)),
        content: CustomTextFormField(
          hintText: 'Enter new password',
          obscureText: true,
          controller: controller,
        ),
        actionsPadding: const EdgeInsets.all(24),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('CANCEL', style: AppTextStyles.labelMd.copyWith(color: Colors.black38, fontWeight: FontWeight.w900)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomElevatedButton(
                  text: 'UPDATE',
                  minimumSize: const Size(0, 48),
                  onPressed: () async {
                    if (controller.text.length >= 6) {
                      final authRepo = context.read<AuthRepository>();
                      await authRepo.updatePassword(controller.text);
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(String name, String email, String? avatarUrl) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.6),
                border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
                image: avatarUrl != null
                    ? DecorationImage(
                        image: NetworkImage(avatarUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: avatarUrl == null
                  ? Center(
                      child: Icon(Icons.person_rounded, size: 80, color: AppColors.kPrimary.withValues(alpha: 0.2)),
                    )
                  : null,
            ),
            GestureDetector(
              onTap: _isUploading ? null : () => _pickAndUploadImage(context),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.kPrimary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kPrimary.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: _isUploading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                      )
                    : const Icon(Icons.camera_alt_rounded, size: 20, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(name, style: AppTextStyles.headlineLg.copyWith(fontSize: 26, letterSpacing: 1, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text(email.toUpperCase(), style: AppTextStyles.labelMd.copyWith(color: Colors.black38, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStatsSection(String notes, String folders) {
    return Row(
      children: [
        _buildStatCard('NOTES', notes, Icons.description_rounded),
        const SizedBox(width: 24),
        _buildStatCard('FOLDERS', folders, Icons.folder_rounded),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(36),
          border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.kPrimary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.kPrimary, size: 24),
            ),
            const SizedBox(height: 16),
            Text(value, style: AppTextStyles.headlineLg.copyWith(fontSize: 28, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text(label, style: AppTextStyles.labelMd.copyWith(color: Colors.black26, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        leading: Icon(icon, color: AppColors.kPrimary, size: 24),
        title: Text(title, style: AppTextStyles.headlineSm.copyWith(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black12, size: 14),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return CustomElevatedButton(
      text: 'LOGOUT',
      backgroundColor: Colors.redAccent.withValues(alpha: 0.08),
      textColor: Colors.redAccent,
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
    );
  }
}

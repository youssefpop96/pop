import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';
import 'package:pop/features/note/view_models/cubit/note_cubit.dart';

class AddFolderScreen extends StatefulWidget {
  const AddFolderScreen({super.key});

  @override
  State<AddFolderScreen> createState() => _AddFolderScreenState();
}

class _AddFolderScreenState extends State<AddFolderScreen> {
  final TextEditingController _nameController = TextEditingController();
  
  int _selectedColorIndex = 0;
  int _selectedIconIndex = 0;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _createFolder() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a folder name', style: AppTextStyles.labelMd.copyWith(color: Colors.white)),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    context.read<NoteCubit>().createFolder(
      name: _nameController.text.trim(),
      colorIndex: _selectedColorIndex,
      iconName: 'icon_$_selectedIconIndex',
    );
    
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Folder Created Successfully!'),
        backgroundColor: AppColors.kPrimary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.kBackground,
        gradient: LinearGradient(
          colors: [Color(0xFFE0F7FA), Color(0xFFE8EAF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF006064)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'New Folder',
            style: AppTextStyles.headlineSm.copyWith(
              color: const Color(0xFF006064),
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FOLDER NAME',
                  style: AppTextStyles.labelMd.copyWith(
                    color: const Color(0xFF006064),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextFormField(
                    controller: _nameController,
                    style: AppTextStyles.labelMd.copyWith(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Enter folder name...',
                      hintStyle: AppTextStyles.labelMd.copyWith(
                        color: Colors.black26,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                Text(
                  'IDENTITY COLOR',
                  style: AppTextStyles.labelMd.copyWith(
                    color: const Color(0xFF006064),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    AppColors.kFolderColors.length,
                    (index) => _buildColorOption(index),
                  ),
                ),
                const SizedBox(height: 32),
                
                Text(
                  'SELECT ICON',
                  style: AppTextStyles.labelMd.copyWith(
                    color: const Color(0xFF006064),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: List.generate(
                    AppColors.kFolderIcons.length,
                    (index) => _buildIconOption(index),
                  ),
                ),
                const SizedBox(height: 48),
                
                GestureDetector(
                  onTap: _createFolder,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF006064),
                          AppColors.kFolderColors[_selectedColorIndex],
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.kFolderColors[_selectedColorIndex].withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Create Folder',
                        style: AppTextStyles.labelMd.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.labelMd.copyWith(
                        color: const Color(0xFF006064),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorOption(int index) {
    bool isSelected = _selectedColorIndex == index;
    Color color = AppColors.kFolderColors[index];
    
    return GestureDetector(
      onTap: () => setState(() => _selectedColorIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ]
              : null,
          color: color,
        ),
      ),
    );
  }

  Widget _buildIconOption(int index) {
    bool isSelected = _selectedIconIndex == index;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedIconIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? const Color(0xFF006064) : const Color(0xFF00E5FF).withValues(alpha: 0.1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF006064).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ]
              : null,
        ),
        child: Icon(
          AppColors.kFolderIcons[index],
          color: isSelected ? Colors.white : const Color(0xFF006064),
          size: 24,
        ),
      ),
    );
  }
}

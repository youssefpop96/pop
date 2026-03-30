import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/core/models/folder_model.dart';
import 'package:pop/features/note/view_models/cubit/note_cubit.dart';

class AddFolderScreen extends StatefulWidget {
  final FolderModel? folderToEdit;
  const AddFolderScreen({super.key, this.folderToEdit});

  @override
  State<AddFolderScreen> createState() => _AddFolderScreenState();
}

class _AddFolderScreenState extends State<AddFolderScreen> {
  final TextEditingController _nameController = TextEditingController();
  int _selectedColorIndex = 0;
  int _selectedIconIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.folderToEdit != null) {
      _nameController.text = widget.folderToEdit!.name;
      _selectedColorIndex = widget.folderToEdit!.colorIndex;
      if (widget.folderToEdit!.iconName != null && widget.folderToEdit!.iconName!.startsWith('icon_')) {
        _selectedIconIndex = int.tryParse(widget.folderToEdit!.iconName!.split('_')[1]) ?? 0;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveFolder() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a folder name')),
      );
      return;
    }

    final cubit = context.read<NoteCubit>();
    if (widget.folderToEdit != null) {
      cubit.updateFolder(
        FolderModel(
          id: widget.folderToEdit!.id,
          userId: widget.folderToEdit!.userId,
          name: _nameController.text.trim(),
          colorIndex: _selectedColorIndex,
          iconName: 'icon_$_selectedIconIndex',
          createdAt: widget.folderToEdit!.createdAt,
        ),
      );
    } else {
      cubit.createFolder(
        name: _nameController.text.trim(),
        colorIndex: _selectedColorIndex,
        iconName: 'icon_$_selectedIconIndex',
      );
    }
    
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(widget.folderToEdit != null ? 'Folder Updated!' : 'Folder Created!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.folderToEdit != null;
    
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
            isEditing ? 'Edit Folder' : 'New Folder',
            style: const TextStyle(
              color: Color(0xFF006064),
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
                const Text(
                  'FOLDER NAME',
                  style: TextStyle(
                    color: Color(0xFF006064),
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
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Enter folder name...',
                      hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                const Text(
                  'IDENTITY COLOR',
                  style: TextStyle(
                    color: Color(0xFF006064),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 16),
                // تم استبدال Row بـ Wrap لحل مشكلة الـ Overflow
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(
                    AppColors.kFolderGradients.length,
                    (index) => _buildColorOption(index),
                  ),
                ),
                const SizedBox(height: 32),
                
                const Text(
                  'SELECT ICON',
                  style: TextStyle(
                    color: Color(0xFF006064),
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
                  onTap: _saveFolder,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.kFolderGradients[_selectedColorIndex % AppColors.kFolderGradients.length],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.kFolderGradients[_selectedColorIndex % AppColors.kFolderGradients.length][1].withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        isEditing ? 'Update Folder' : 'Create Folder',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                if (isEditing) ...[
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: _deleteFolder,
                      child: const Text('Delete Folder', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF006064),
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

  void _deleteFolder() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Folder?'),
        content: const Text('This will delete the folder and its notes. Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<NoteCubit>().deleteFolder(widget.folderToEdit!.id);
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Close edit screen
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(int index) {
    bool isSelected = _selectedColorIndex == index;
    Color color = AppColors.kFolderGradients[index][0];
    
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
          gradient: LinearGradient(colors: AppColors.kFolderGradients[index]),
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

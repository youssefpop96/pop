import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pop/features/note/view_models/cubit/note_cubit.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          context.read<NoteCubit>().searchNotes(value);
        },
        style: AppTextStyles.bodyLg,
        decoration: InputDecoration(
          hintText: 'SEARCH YOUR THOUGHTS...',
          hintStyle: AppTextStyles.labelMd.copyWith(color: Colors.black26),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.kPrimary, size: 22),
          suffixIcon: const Icon(Icons.tune_rounded, color: AppColors.kPrimary, size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
        ),
      ),
    );
  }
}

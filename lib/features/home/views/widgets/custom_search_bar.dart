import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pop/features/note/view_models/cubit/note_cubit.dart';
import '../../../../../core/utilities/styles/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kLightGreyColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        onChanged: (value) {
          context.read<NoteCubit>().searchNotes(value);
        },
        decoration: const InputDecoration(
          hintText: 'Search notes...',
          hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
          prefixIcon: Icon(Icons.search, color: Colors.black38),
          suffixIcon: Icon(Icons.mic_none, color: Colors.black38),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}

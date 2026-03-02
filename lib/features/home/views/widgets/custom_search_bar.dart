import 'package:flutter/material.dart';
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
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: const TextStyle(color: Colors.black38, fontSize: 16),
          prefixIcon: const Icon(Icons.search, color: Colors.black38),
          suffixIcon: const Icon(Icons.mic_none, color: Colors.black38),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}

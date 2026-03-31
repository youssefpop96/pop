import 'package:flutter/material.dart';
import '../../models/on_boarding_model.dart';
import '../../../../core/utilities/styles/app_text_styles.dart';
import '../../../../core/utilities/styles/app_colors.dart';

class OnboardingPageItem extends StatelessWidget {
  final OnboardingModel item;
  final VoidCallback? onSkip;

  const OnboardingPageItem({super.key, required this.item, this.onSkip});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.kBackground,
        gradient: LinearGradient(
          colors: [Color(0xFFE0F7FA), Color(0xFFE8EAF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 60),
          // Header Logo & Skip
          Row(
            children: [
              const Icon(Icons.edit_note_rounded, color: Color(0xFF00E5FF), size: 28),
              const SizedBox(width: 8),
              Text(
                'Lumina Cyber',
                style: AppTextStyles.headlineSm.copyWith(
                  color: const Color(0xFF8E24AA),
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onSkip,
                child: Text(
                  'SKIP',
                  style: AppTextStyles.labelMd.copyWith(
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const Spacer(flex: 1),
          
          // Image - Reduced height to prevent overlap
          Center(
            child: Image.asset(
              item.imagePath,
              height: size.height * 0.35, // Responsive height
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.notes, size: 100, color: Colors.black26),
            ),
          ),
          
          const Spacer(flex: 1),
          
          // Title
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.headlineLg.copyWith(
              color: const Color(0xFF003440),
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              item.description,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMd.copyWith(
                color: Colors.black54,
                height: 1.4,
                fontSize: 15,
              ),
            ),
          ),
          
          // Bottom spacing to leave room for indicators and buttons in Stack
          const SizedBox(height: 180),
        ],
      ),
    );
  }
}

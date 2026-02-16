import 'package:flutter/material.dart';
import '../onboarding_item.dart';
import 'onboarding_bottom_actions.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: item.bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 100),
          
          // Title
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w900,
              height: 1.0,
              color: Color(0xFF1A1A1A),
              letterSpacing: -1,
            ),
          ),

          const Spacer(),

          // Image (Illustration)
          Center(
            child: Image.asset(
              item.imagePath,
              height: 280,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => 
                  const Icon(Icons.broken_image_outlined, size: 100),
            ),
          ),

          const Spacer(),

          // Description
          Text(
            item.description,
            style: const TextStyle(
              fontSize: 18,
              height: 1.3,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A),
            ),
          ),

          const SizedBox(height: 40),

          // Bottom Actions
          const OnboardingBottomActions(),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

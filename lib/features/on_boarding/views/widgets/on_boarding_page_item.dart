import 'package:flutter/material.dart';
import '../../models/on_boarding_model.dart';
import '../../../../core/utilities/styles/app_text_styles.dart';
import 'next_page_button.dart';

class OnboardingPageItem extends StatelessWidget {
  final OnboardingModel item;

  const OnboardingPageItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(flex: 2),
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOutSine,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 15 * (1 - (2 * value - 1).abs())),
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: item.bgColor.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  item.imagePath,
                  height: 280,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.notes_rounded, size: 120, color: item.bgColor),
                ),
              ),
            ),
          ),
          const Spacer(flex: 3),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1000),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title.toUpperCase(),
                  style: AppTextStyles.headlineLg.copyWith(
                    fontSize: 32,
                    height: 1.1,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item.description.toUpperCase(),
                  style: AppTextStyles.labelMd.copyWith(
                    color: Colors.black26,
                    fontSize: 11,
                    height: 1.6,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 64),
          const NextPageButton(),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

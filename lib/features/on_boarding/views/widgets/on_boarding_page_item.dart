import 'package:flutter/material.dart';
import '../../models/on_boarding_model.dart';
import '../../../../core/utilities/app_text_styles.dart';
import 'next_page_button.dart';

class OnboardingPageItem extends StatelessWidget {
  final OnboardingModel item;

  const OnboardingPageItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: item.bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 100),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Text(item.title, style: AppTextStyles.title64Black900),
          ),
          const Spacer(),
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOutSine,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 10 * (1 - (2 * value - 1).abs())),
                  child: child,
                );
              },
              child: Image.asset(
                item.imagePath,
                height: 320,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.notes, size: 100, color: Colors.black26),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Text(
              item.description,
              style: AppTextStyles.title18Black500.copyWith(
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 48),
          const NextPageButton(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

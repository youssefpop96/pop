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
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 100),
          Text(
            item.title,
            style: AppTextStyles.title64Black900,
          ),
          const Spacer(),
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
          Text(
            item.description,
            style: AppTextStyles.title18Black500,
          ),
          const SizedBox(height: 40),
          const NextPageButton(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

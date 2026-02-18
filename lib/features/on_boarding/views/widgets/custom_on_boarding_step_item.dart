import 'package:flutter/material.dart';
import '../../models/on_boarding_step_model.dart';
import 'next_page_button.dart';

class CustomOnBoardingStepItem extends StatelessWidget {
  final OnBoardingStepModel item;

  const CustomOnBoardingStepItem({super.key, required this.item});

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
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w900,
              height: 1.0,
              color: Color(0xFF1A1A1A),
              letterSpacing: -1,
            ),
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
            style: const TextStyle(
              fontSize: 18,
              height: 1.3,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 40),
          const NextPageButton(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

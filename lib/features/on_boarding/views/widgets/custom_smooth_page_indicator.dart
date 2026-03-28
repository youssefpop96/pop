import 'package:flutter/material.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';

class CustomSmoothPageIndicator extends StatelessWidget {
  final int itemCount;
  final int currentPage;

  const CustomSmoothPageIndicator({
    super.key,
    required this.itemCount,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 60,
      left: 32,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(itemCount, (index) {
          final isCurrent = index == currentPage;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 6,
            width: isCurrent ? 24 : 6,
            decoration: BoxDecoration(
              color: isCurrent ? AppColors.kPrimary : Colors.black12,
              borderRadius: BorderRadius.circular(100),
            ),
          );
        }),
      ),
    );
  }
}

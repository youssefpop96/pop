import 'package:flutter/material.dart';

class OnboardingProgressIndicator extends StatelessWidget {
  final int itemCount;
  final int currentPage;

  const OnboardingProgressIndicator({
    super.key,
    required this.itemCount,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      left: 32,
      right: 32,
      child: Row(
        children: List.generate(itemCount, (index) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 2,
              decoration: BoxDecoration(
                color: index == currentPage 
                    ? Colors.black 
                    : Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          );
        }),
      ),
    );
  }
}

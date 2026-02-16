import 'package:flutter/material.dart';
import 'onboarding_item.dart';

class OnboardingData {
  static final List<OnboardingItem> items = [
    OnboardingItem(
      title: "Risk\nBrave",
      description:
          "Accept major risks to accelerate AI adoption and achieve market leadership.",
      bgColor: const Color(0xFFFDE3E0),
      imagePath: "assets/onboarding_1.png",
    ),
    OnboardingItem(
      title: "Wise\nSteps",
      description:
          "Take calculated and strategic steps to balance risks and drive AI-driven progress.",
      bgColor: const Color(0xFFFBFDE1),
      imagePath: "assets/onboarding_2.png",
    ),
    OnboardingItem(
      title: "Stay\nSafe",
      description:
          "Lower implementation risks by adhering to regulations and adopting AI prudently.",
      bgColor: const Color(0xFFFFE6D3),
      imagePath: "assets/onboarding_3.png",
    ),
  ];
}

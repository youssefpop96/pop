import 'package:flutter/material.dart';
import '../../models/on_boarding_step_model.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit {
  int currentPage = 0;

  final List<OnBoardingStepModel> items = [
    OnBoardingStepModel(
      title: "Risk\nBrave",
      description:
          "Accept major risks to accelerate AI adoption and achieve market leadership.",
      bgColor: const Color(0xFFFDE3E0),
      imagePath: "assets/onboarding_1.png",
    ),
    OnBoardingStepModel(
      title: "Wise\nSteps",
      description:
          "Take calculated and strategic steps to balance risks and drive AI-driven progress.",
      bgColor: const Color(0xFFFBFDE1),
      imagePath: "assets/onboarding_2.png",
    ),
    OnBoardingStepModel(
      title: "Stay\nSafe",
      description:
          "Lower implementation risks by adhering to regulations and adopting AI prudently.",
      bgColor: const Color(0xFFFFE6D3),
      imagePath: "assets/onboarding_3.png",
    ),
  ];

  void updatePage(int index) {
    currentPage = index;
    // Note: Since you'll likely use BlocProvider, I'm setting this up for future Cubit usage.
    // For now, I'll keep the logic simple to match your request.
  }
}

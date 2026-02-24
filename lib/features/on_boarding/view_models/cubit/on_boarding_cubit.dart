import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/on_boarding_model.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingInitial());

  int currentPage = 0;

  final List<OnboardingModel> items = [
    OnboardingModel(
      title: "Risk\nBrave",
      description:
          "Accept major risks to accelerate AI adoption and achieve market leadership.",
      bgColor: const Color(0xFFFDE3E0),
      imagePath: "assets/onboarding_1.png",
    ),
    OnboardingModel(
      title: "Wise\nSteps",
      description:
          "Take calculated and strategic steps to balance risks and drive AI-driven progress.",
      bgColor: const Color(0xFFFBFDE1),
      imagePath: "assets/onboarding_2.png",
    ),
    OnboardingModel(
      title: "Stay\nSafe",
      description:
          "Lower implementation risks by adhering to regulations and adopting AI prudently.",
      bgColor: const Color(0xFFFFE6D3),
      imagePath: "assets/onboarding_3.png",
    ),
  ];

  void updatePage(int index) {
    currentPage = index;
    emit(OnBoardingPageChanged(index));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pop/features/on_boarding/models/on_boarding_step_model.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingInitial());

  int currentPage = 0;

  final List<OnBoardingStepModel> items = [
    OnBoardingStepModel(
      title: "Risk\nBrave",
      description:
          "Accept major risks to accelerate AI adoption and achieve market leadership.",
      bgColor: AppColors.kOnboardingPink,
      imagePath: "assets/onboarding_1.png",
    ),
    OnBoardingStepModel(
      title: "Wise\nSteps",
      description:
          "Take calculated and strategic steps to balance risks and drive AI-driven progress.",
      bgColor: AppColors.kOnboardingYellow,
      imagePath: "assets/onboarding_2.png",
    ),
    OnBoardingStepModel(
      title: "Stay\nSafe",
      description:
          "Lower implementation risks by adhering to regulations and adopting AI prudently.",
      bgColor: AppColors.kOnboardingPeach,
      imagePath: "assets/onboarding_3.png",
    ),
  ];

  void updatePage(int index) {
    currentPage = index;
    emit(OnBoardingPageChanged(index));
  }
}

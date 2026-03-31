import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/on_boarding_model.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingInitial());

  int currentPage = 0;

  final List<OnboardingModel> items = [
    OnboardingModel(
      title: "Organize your notes with style",
      description:
          "Arrange your thoughts in colorful, custom folders for easy access.",
      bgColor: const Color(0xFFEAF9FF),
      imagePath: "assets/onboarding_1.png",
    ),
    OnboardingModel(
      title: "Professional Writing Experience",
      description:
          "Capture every detail with our advanced rich text editor.",
      bgColor: const Color(0xFFEAF9FF),
      imagePath: "assets/onboarding_2.png",
    ),
    OnboardingModel(
      title: "Ultimate Security for Your Notes",
      description:
          "Protect your privacy with a custom PIN and end-to-end encryption.",
      bgColor: const Color(0xFFEAF9FF),
      imagePath: "assets/onboarding_3.png",
    ),
  ];

  void updatePage(int index) {
    currentPage = index;
    emit(OnBoardingPageChanged(index));
  }
}

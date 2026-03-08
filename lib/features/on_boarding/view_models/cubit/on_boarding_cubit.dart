import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/on_boarding_model.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingInitial());

  int currentPage = 0;

  final List<OnboardingModel> items = [
    OnboardingModel(
      title: "Write Your\nStory",
      description:
          "Capture every thought, from brilliant ideas to simple daily moments, in your personal space.",

      bgColor: const Color(0xFFFDE3E0),
      imagePath: "assets/onboarding_1.png",
    ),
    OnboardingModel(
      title: "Smartly\nOrganized",
      description:
          "Keep your work, study, and life separate yet accessible. Beautiful folders for a focused mind.",
      bgColor: const Color(0xFFFBFDE1),
      imagePath: "assets/onboarding_2.png",
    ),
    OnboardingModel(
      title: "Find it\nInstantly",
      description:
          "Your second brain remembers everything. Powerful search helps you recall any note in a splash.",
      bgColor: const Color(0xFFFFE6D3),
      imagePath: "assets/onboarding_3.png",
    ),
    OnboardingModel(
      title: "Stay\nInspired",
      description:
          "Turn your reflections into reality. The perfect tool for thinkers, creators, and dreamers.",
      bgColor: Colors.white,
      imagePath: "assets/onboarding_4.png",
    ),
  ];

  void updatePage(int index) {
    currentPage = index;
    emit(OnBoardingPageChanged(index));
  }
}

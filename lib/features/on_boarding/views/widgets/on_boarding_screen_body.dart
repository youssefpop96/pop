import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_models/cubit/on_boarding_cubit.dart';
import 'onboarding_page_item.dart';
import 'custom_smooth_page_indicator.dart';

class OnBoardingScreenBody extends StatefulWidget {
  const OnBoardingScreenBody({super.key});

  @override
  State<OnBoardingScreenBody> createState() => _OnBoardingScreenBodyState();
}

class _OnBoardingScreenBodyState extends State<OnBoardingScreenBody> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnBoardingCubit>();
    final items = cubit.items;

    return Scaffold(
      body: BlocBuilder<OnBoardingCubit, OnBoardingState>(
        builder: (context, state) {
          int currentPage = cubit.currentPage;
          if (state is OnBoardingPageChanged) {
            currentPage = state.index;
          }

          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  cubit.updatePage(index);
                },
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return OnboardingPageItem(item: items[index]);
                },
              ),
              CustomSmoothPageIndicator(
                itemCount: items.length,
                currentPage: currentPage,
              ),
            ],
          );
        },
      ),
    );
  }
}

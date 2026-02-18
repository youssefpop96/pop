import 'package:flutter/material.dart';
import '../../view_models/cubit/on_boarding_cubit.dart';
import '../widgets/custom_on_boarding_step_item.dart';
import '../widgets/custom_smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  final OnBoardingCubit _cubit = OnBoardingCubit(); // Simple instance for now
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = _cubit.items;

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: items.length,
            itemBuilder: (context, index) {
              return CustomOnBoardingStepItem(item: items[index]);
            },
          ),
          CustomSmoothPageIndicator(
            itemCount: items.length,
            currentPage: _currentPage,
          ),
        ],
      ),
    );
  }
}

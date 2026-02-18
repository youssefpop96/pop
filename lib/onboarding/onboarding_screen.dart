import 'package:flutter/material.dart';
import 'onboarding_data.dart';
import 'widgets/onboarding_page.dart';
import 'widgets/onboarding_progress_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = OnboardingData.items;

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
              return OnboardingPage(item: items[index]);
            },
          ),

          // Top Progress Indicator
          OnboardingProgressIndicator(
            itemCount: items.length,
            currentPage: _currentPage,
          ),
        ],
      ),
    );
  }
}

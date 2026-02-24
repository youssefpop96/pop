import 'package:flutter/material.dart';
import 'package:pop/core/utilities/sizes/size_config.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import '../../models/on_boarding_model.dart';
import '../widgets/onboarding_page_item.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingModel> _items = [
    OnboardingModel(
      title: "Risk\nBrave",
      description:
          "Accept major risks to accelerate AI adoption and achieve market leadership.",
      bgColor: AppColors.kOnboardingPink,
      imagePath: "assets/onboarding_1.png",
    ),
    OnboardingModel(
      title: "Wise\nSteps",
      description:
          "Take calculated and strategic steps to balance risks and drive AI-driven progress.",
      bgColor: AppColors.kOnboardingYellow,
      imagePath: "assets/onboarding_2.png",
    ),
    OnboardingModel(
      title: "Stay\nSafe",
      description:
          "Lower implementation risks by adhering to regulations and adopting AI prudently.",
      bgColor: AppColors.kOnboardingPeach,
      imagePath: "assets/onboarding_3.png",
    ),
  ];

  @override
  void didChangeDependencies() {
    SizeConfig.init(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return OnboardingPageItem(item: _items[index]);
            },
          ),

          // Top Progress Indicator
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              children: List.generate(_items.length, (index) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 4,
                    decoration: BoxDecoration(
                      color: index == _currentPage
                          ? Colors.black
                          : Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

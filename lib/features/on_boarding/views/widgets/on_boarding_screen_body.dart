import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';
import '../../view_models/cubit/on_boarding_cubit.dart';
import 'on_boarding_page_item.dart';
import 'package:pop/features/auth/sign_in/views/screens/sign_in_screen.dart';

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

  void _navigateToSignIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
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
                  return OnboardingPageItem(
                    item: items[index],
                    onSkip: _navigateToSignIn, // تفعيل زر Skip
                  );
                },
              ),
              Positioned(
                bottom: 40,
                left: 24,
                right: 24,
                child: Column(
                  children: [
                    _buildIndicator(currentPage, items.length),
                    const SizedBox(height: 32),
                    _buildButtons(currentPage, items.length),
                    if (currentPage == items.length - 1) ...[
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock_outline_rounded, size: 14, color: Colors.black26),
                          const SizedBox(width: 8),
                          Text(
                            'END-TO-END ENCRYPTION',
                            style: AppTextStyles.labelMd.copyWith(
                              color: Colors.black26,
                              fontSize: 10,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIndicator(int currentPage, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        bool isActive = currentPage == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 24 : 8,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF8E24AA) : const Color(0xFF00E5FF).withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildButtons(int currentPage, int count) {
    bool isLastPage = currentPage == count - 1;
    bool isFirstPage = currentPage == 0;

    return Row(
      children: [
        if (!isFirstPage)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      'Previous',
                      style: AppTextStyles.labelMd.copyWith(
                        color: const Color(0xFF006064),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              if (isLastPage) {
                _navigateToSignIn();
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF006064), Color(0xFF8E24AA)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8E24AA).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLastPage ? 'Get Started' : 'Next',
                      style: AppTextStyles.labelMd.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (!isLastPage) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

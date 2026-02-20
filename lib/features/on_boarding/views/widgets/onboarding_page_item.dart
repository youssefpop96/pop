import 'package:flutter/material.dart';
import 'package:pop/core/components/custom_elevated_button.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';
import '../../models/onboarding_model.dart';

class OnboardingPageItem extends StatelessWidget {
  final OnboardingModel item;

  const OnboardingPageItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: item.bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 100),
          Text(item.title, style: AppTextStyles.title48BlackBold),
          const Spacer(flex: 2),
          Center(child: Icon(item.icon, size: 150, color: Colors.black87)),
          const Spacer(flex: 2),
          Text(item.description, style: AppTextStyles.body18Black87),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: CustomElevatedButton(text: 'Log In', onPressed: () {}),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Don't have account?",
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "Create now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pop/core/components/custom_elevated_button.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';
import 'package:pop/features/auth/sign_in/views/screens/sign_in_screen.dart';
import 'package:pop/features/auth/sign_up/views/screens/sign_up_screen.dart';

class NextPageButton extends StatelessWidget {
  const NextPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomElevatedButton(
          text: 'Get Started',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()),
            );
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ALREADY HAVE AN ACCOUNT? ',
              style: AppTextStyles.labelMd.copyWith(
                color: Colors.black38,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              },
              child: Text(
                'LOG IN',
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.kPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

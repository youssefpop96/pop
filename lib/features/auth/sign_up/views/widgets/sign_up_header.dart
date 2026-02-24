import 'package:flutter/material.dart';
import '../../../../../core/utilities/app_text_styles.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Get started free.',
          style: AppTextStyles.title24BlackBold,
        ),
        const SizedBox(height: 8),
        const Text(
          'Free forever. No credit card needed.',
          style: AppTextStyles.title16GreyW500,
        ),
      ],
    );
  }
}

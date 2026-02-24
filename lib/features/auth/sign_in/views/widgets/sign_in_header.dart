import 'package:flutter/material.dart';

import '../../../../../core/utilities/app_text_styles.dart';

class SignInHeader extends StatelessWidget {
  const SignInHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.waving_hand,
          color: Color(0xFFFFD700),
          size: 28, // Using fixed size for now or SizeConfig.width * 0.08
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Welcome Back!', style: AppTextStyles.title28Black87Bold),
              Text(
                'Login to continue your journey',
                style: AppTextStyles.title16GreyW500,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

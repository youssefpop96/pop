import 'package:flutter/material.dart';
import 'sign_up_form_fields.dart';
import '../../../../../core/components/custom_elevated_button.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SignUpFormFields(),
        const SizedBox(height: 30),
        CustomElevatedButton(
          text: 'Sign up',
          onPressed: () {},
        ),
      ],
    );
  }
}

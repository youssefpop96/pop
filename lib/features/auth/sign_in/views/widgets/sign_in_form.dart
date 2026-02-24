import 'package:flutter/material.dart';
import 'sign_in_form_fields.dart';
import '../../../../../core/components/custom_elevated_button.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SignInFormFields(),
        const SizedBox(height: 10),
        const Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Forgot password?',
            style: TextStyle(color: Colors.black45, fontSize: 13),
          ),
        ),
        const SizedBox(height: 30),
        CustomElevatedButton(
          text: 'Sign in',
          onPressed: () {},
        ),
      ],
    );
  }
}

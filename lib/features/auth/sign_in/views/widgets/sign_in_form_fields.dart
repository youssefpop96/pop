import 'package:flutter/material.dart';
import '../../../../../core/components/custom_text_form_field.dart';

class SignInFormFields extends StatelessWidget {
  const SignInFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomTextFormField(
          hintText: 'Email Address',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          hintText: 'Password',
          obscureText: true,
          suffixIcon: IconButton(
            icon: const Icon(Icons.visibility_off_outlined, color: Colors.black26),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

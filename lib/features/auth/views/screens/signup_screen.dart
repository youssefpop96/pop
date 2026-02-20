import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/social_login_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF143BA),
      body: Column(
        children: [
          const SizedBox(height: 80),
          const Center(
            child: Text(
              'PoP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Get started free.',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Free forever. No credit card needed.',
                      style: TextStyle(color: Colors.black45, fontSize: 14),
                    ),
                    const SizedBox(height: 40),
                    const CustomTextField(
                      labelText: 'Email Address',
                      hintText: 'youssef@example.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const CustomTextField(
                      labelText: 'Your Name',
                      hintText: 'Youssef Pop',
                    ),
                    const CustomTextField(
                      labelText: 'Password',
                      hintText: '••••••••',
                      obscureText: true,
                      suffixIcon: Icon(Icons.visibility_off_outlined, color: Colors.black26),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A1A1A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: const [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Or sign up with', style: TextStyle(color: Colors.black26)),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        SocialLoginButton(
                          label: 'Google',
                          iconPath: 'assets/google.jpg',
                          onTap: () {},
                        ),
                        const SizedBox(width: 16),
                        SocialLoginButton(
                          label: 'Facebook',
                          iconPath: 'assets/facebook.jpg',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

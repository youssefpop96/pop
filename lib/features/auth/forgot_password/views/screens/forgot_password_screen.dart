import 'package:flutter/material.dart';
import '../widgets/forgot_password_body.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF143BA),
      body: ForgotPasswordBody(),
    );
  }
}

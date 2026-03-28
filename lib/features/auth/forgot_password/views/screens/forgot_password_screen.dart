import 'package:flutter/material.dart';
import 'package:pop/core/components/custom_elevated_button.dart';
import 'package:pop/core/components/custom_text_form_field.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';
import 'package:pop/features/auth/widgets/auth_layout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('EMAIL IS REQUIRED'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;
      await supabase.auth.resetPasswordForEmail(email);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('RESET LINK SENT! CHECK YOUR EMAIL'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.kPrimary,
        ));
        Navigator.pop(context);
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message.toUpperCase()),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('AN UNEXPECTED ERROR OCCURRED'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AuthLayout(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'RESET PASSWORD',
                  style: AppTextStyles.headlineLg.copyWith(
                    fontSize: 24,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: Colors.black26),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'ENTER YOUR EMAIL ADDRESS TO RECEIVE A SECURE RESET LINK.',
              style: AppTextStyles.labelMd.copyWith(
                color: Colors.black38,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 56),
            CustomTextFormField(
              hintText: 'Email Address',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 48),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomElevatedButton(
                    text: 'Send link',
                    onPressed: _resetPassword,
                  ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

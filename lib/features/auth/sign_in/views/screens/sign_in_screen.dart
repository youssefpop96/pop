import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/sign_up/views/screens/sign_up_screen.dart';
import '../../../../auth/forgot_password/views/screens/forgot_password_screen.dart';
import '../../../../../core/components/custom_text_form_field.dart';
import '../../../../../core/components/custom_elevated_button.dart';
import '../../../../../core/components/social_login_button.dart';
import '../../../../../core/utilities/styles/app_text_styles.dart';
import '../../../../../core/utilities/styles/app_colors.dart';
import 'package:pop/features/auth/widgets/auth_layout.dart';
import 'package:pop/features/home/views/screens/home_screen.dart';
import 'package:pop/features/auth/sign_in/view_models/cubit/sign_in_cubit.dart';
import 'package:pop/core/repositories/auth_repository.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(context.read<AuthRepository>()),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: _SignInBody(),
      ),
    );
  }
}

class _SignInBody extends StatelessWidget {
  const _SignInBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('WELCOME BACK!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.kPrimary,
          ));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (state is SignInFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errMessage.toUpperCase()),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
          ));
        }
      },
      builder: (context, state) {
        return AuthLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 48),
              _buildForm(context, state),
              const SizedBox(height: 40),
              _buildDivider(),
              const SizedBox(height: 32),
              _buildSocialLogin(context),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WELCOME BACK',
          style: AppTextStyles.headlineLg.copyWith(
            fontSize: 28,
            letterSpacing: 2,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              "DON'T HAVE AN ACCOUNT? ",
              style: AppTextStyles.labelMd.copyWith(
                color: Colors.black38,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              child: Text(
                'GET STARTED',
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.kPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context, SignInState state) {
    final cubit = context.read<SignInCubit>();
    return Form(
      key: cubit.signInKey,
      child: Column(
        children: [
          CustomTextFormField(
            hintText: 'Email Address',
            keyboardType: TextInputType.emailAddress,
            onChanged: (val) => cubit.email = val,
            validator: (val) =>
                val == null || val.isEmpty ? 'REQUIRED FIELD' : null,
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            hintText: 'Password',
            obscureText: true,
            onChanged: (val) => cubit.password = val,
            validator: (val) =>
                val == null || val.isEmpty ? 'REQUIRED FIELD' : null,
            suffixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: Colors.black12,
              size: 20,
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ForgotPasswordScreen(),
                  ),
                );
              },
              child: Text(
                'FORGOT PASSWORD?',
                style: AppTextStyles.labelMd.copyWith(
                  color: Colors.black26,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),
          state is SignInLoading
              ? const CircularProgressIndicator()
              : CustomElevatedButton(
                  text: 'Sign in',
                  onPressed: () => cubit.signIn(),
                ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.black.withValues(alpha: 0.05))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'OR CONTINUE WITH',
            style: AppTextStyles.labelMd.copyWith(
              color: Colors.black26,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.black.withValues(alpha: 0.05))),
      ],
    );
  }

  Widget _buildSocialLogin(BuildContext context) {
    return Row(
      children: [
        SocialLoginButton(
          label: 'Google',
          iconPath: 'assets/google.jpg',
          onTap: () => context.read<SignInCubit>().signInWithGoogle(),
        ),
        const SizedBox(width: 20),
        SocialLoginButton(
          label: 'Facebook',
          iconPath: 'assets/facebook.jpg',
          onTap: () {},
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';
import 'package:pop/features/auth/widgets/auth_layout.dart';
import 'package:pop/features/auth/sign_in/views/screens/sign_in_screen.dart';
import 'package:pop/features/auth/sign_up/view_models/cubit/sign_up_cubit.dart';
import 'package:pop/features/home/views/screens/home_screen.dart';
import 'package:pop/core/repositories/auth_repository.dart';
import 'package:pop/core/components/custom_text_form_field.dart';
import 'package:pop/core/components/custom_elevated_button.dart';
import 'package:pop/core/components/social_login_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(context.read<AuthRepository>()),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: _SignUpBody(),
      ),
    );
  }
}

class _SignUpBody extends StatelessWidget {
  const _SignUpBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.kPrimary,
          ));
          if (Supabase.instance.client.auth.currentSession != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
            );
          }
        } else if (state is SignUpFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errMessage),
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
          'CREATE ACCOUNT',
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
              'ALREADY HAVE AN ACCOUNT? ',
              style: AppTextStyles.labelMd.copyWith(
                color: Colors.black38,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              },
              child: Text(
                'SIGN IN',
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

  Widget _buildForm(BuildContext context, SignUpState state) {
    final cubit = context.read<SignUpCubit>();
    return Form(
      key: cubit.signUpKey,
      child: Column(
        children: [
          CustomTextFormField(
            hintText: 'Email Address',
            keyboardType: TextInputType.emailAddress,
            onChanged: (val) => cubit.email = val,
            validator: (val) =>
                val == null || val.isEmpty ? 'EMAIL IS REQUIRED' : null,
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            hintText: 'Full Name',
            onChanged: (val) => cubit.name = val,
            validator: (val) =>
                val == null || val.isEmpty ? 'NAME IS REQUIRED' : null,
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            hintText: 'Password',
            obscureText: true,
            onChanged: (val) => cubit.password = val,
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'PASSWORD IS REQUIRED';
              }
              if (val.length < 6) {
                return 'MINIMUM 6 CHARACTERS';
              }
              return null;
            },
            suffixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: Colors.black12,
              size: 20,
            ),
          ),
          const SizedBox(height: 48),
          state is SignUpLoading
              ? const CircularProgressIndicator()
              : CustomElevatedButton(
                  text: 'Sign up',
                  onPressed: () => cubit.signUp(),
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
          onTap: () => context.read<SignUpCubit>().signUpWithGoogle(),
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

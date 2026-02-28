import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/sign_up/views/screens/sign_up_screen.dart';
import '../../../../auth/forgot_password/views/screens/forgot_password_screen.dart';
import '../../../../../core/components/custom_text_form_field.dart';
import '../../../../../core/components/custom_elevated_button.dart';
import '../../../../../core/components/social_login_button.dart';
import '../../../../../core/utilities/app_text_styles.dart';
import '../../../../auth/widgets/auth_layout.dart';
import '../../view_models/cubit/sign_in_cubit.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(),
      child: const Scaffold(
        backgroundColor: Color(0xFFFB5BBD),
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
          // Navigate to home
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Welcome! Sign in successful.')),
          );
        } else if (state is SignInFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errMessage)));
        }
      },
      builder: (context, state) {
        return AuthLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 40),
              _buildForm(context, state),
              const SizedBox(height: 30),
              _buildDivider(),
              const SizedBox(height: 30),
              _buildSocialLogin(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              const Icon(Icons.waving_hand, color: Color(0xFFFFD700), size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Welcome Back!',
                      style: AppTextStyles.title28Black87Bold,
                    ),
                    Text(
                      'Login to continue your journey',
                      style: AppTextStyles.title16GreyW500,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()),
            );
          },
          child: const Text(
            'Get Started',
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
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
                val == null || val.isEmpty ? 'Required field' : null,
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            hintText: 'Password',
            obscureText: true,
            onChanged: (val) => cubit.password = val,
            validator: (val) =>
                val == null || val.isEmpty ? 'Required field' : null,
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.visibility_off_outlined,
                color: Colors.black26,
              ),
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 10),
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
              child: const Text(
                'Forgot password?',
                style: TextStyle(color: Colors.black45, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(height: 30),
          state is SignInLoading
              ? const CircularProgressIndicator()
              : CustomElevatedButton(
                  text: 'Sign in',
                  onPressed: () {
                    cubit.signIn();
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: const [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Or sign in with',
            style: TextStyle(color: Colors.black26),
          ),
        ),
        Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialLogin() {
    return Row(
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
    );
  }
}

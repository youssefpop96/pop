import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/sign_in/views/screens/sign_in_screen.dart';
import '../../../../../core/components/custom_text_form_field.dart';
import '../../../../../core/components/custom_elevated_button.dart';
import '../../../../../core/components/social_login_button.dart';
import '../../../../../core/utilities/app_text_styles.dart';
import '../../../../auth/widgets/auth_layout.dart';
import '../../view_models/cubit/sign_up_cubit.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: const Scaffold(
        backgroundColor: Color(0xFFF143BA),
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account Created! Welcome.')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
          );
        } else if (state is SignUpFailure) {
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
        const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
            );
          },
          child: const Text(
            'Sign In',
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
                val == null || val.isEmpty ? 'Please enter your email' : null,
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            hintText: 'Your Name',
            onChanged: (val) => cubit.name = val,
            validator: (val) =>
                val == null || val.isEmpty ? 'Please enter your name' : null,
          ),
          const SizedBox(height: 16),
          CustomTextFormField(
            hintText: 'Password',
            obscureText: true,
            onChanged: (val) => cubit.password = val,
            validator: (val) {
              if (val == null || val.isEmpty)
                return 'Please enter your password';
              if (val.length < 6)
                return 'Password must be at least 6 characters';
              return null;
            },
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.visibility_off_outlined,
                color: Colors.black26,
              ),
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 30),
          state is SignUpLoading
              ? const CircularProgressIndicator()
              : CustomElevatedButton(
                  text: 'Sign up',
                  onPressed: () {
                    cubit.signUp();
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
            'Or sign up with',
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

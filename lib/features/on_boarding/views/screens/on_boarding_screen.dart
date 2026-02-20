import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pop/features/on_boarding/view_models/cubit/on_boarding_cubit.dart';
import '../widgets/on_boarding_screen_body.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnBoardingCubit(),
      child: const Scaffold(body: OnBoardingScreenBody()),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/utilities/styles/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pop/features/home/views/screens/home_screen.dart';
import '../../../on_boarding/views/screens/on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      body: Center(
        child: Text(
          'Pop',
          style: TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
          ),
        ),
      ),
    );
  }
}

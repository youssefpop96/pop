import 'package:flutter/material.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';
import 'package:pop/features/auth/widgets/auth_layout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pop/features/home/views/screens/luminous_main_screen.dart';
import 'package:pop/features/on_boarding/views/screens/on_boarding_screen.dart';

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

    final session = Supabase.instance.client.auth.currentUser;

    if (session != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LuminousMainScreen()),
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
    return Scaffold(
      body: Stack(
        children: [
          const LuminousBackground(),
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 2),
              curve: Curves.easeOutExpo,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.8 + (0.2 * value),
                    child: child,
                  ),
                );
              },
              child: Text(
                'POP',
                style: AppTextStyles.headlineLg.copyWith(
                  color: Colors.white,
                  fontSize: 72,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 20,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      offset: const Offset(0, 10),
                      blurRadius: 20,
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

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pop/features/home/views/screens/home_screen.dart';
import '../../../on_boarding/views/screens/on_boarding_screen.dart';
import '../../../../core/utilities/styles/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
    _handleNavigation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 4));
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
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF8E24AA), // Purple
              Color(0xFF003440), // Dark Navy
              Color(0xFF006064), // Dark Teal
              Color(0xFF8E24AA), // Purple
            ],
            stops: [0.0, 0.4, 0.7, 1.0],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              // Logo Icon with Glassmorphism effect
              _buildCentralLogo(),
              const SizedBox(height: 48),
              // Main Title
              Text(
                'LUMINA',
                style: AppTextStyles.headlineLg.copyWith(
                  color: Colors.white,
                  fontSize: 48,
                  letterSpacing: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              // Underline
              Container(
                width: 40,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF00E5FF),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E5FF).withOpacity(0.8),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              // Slogan
              Text(
                'YOUR THOUGHTS,\nILLUMINATED.',
                textAlign: TextAlign.center,
                style: AppTextStyles.labelMd.copyWith(
                  color: Colors.white.withOpacity(0.6),
                  letterSpacing: 4,
                  fontSize: 12,
                  height: 1.8,
                ),
              ),
              const SizedBox(height: 48),
              // Loading Dots
              _buildLoadingDots(),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCentralLogo() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(35),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.apps_rounded,
              color: Color(0xFF00E5FF),
              size: 40,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == 1 ? const Color(0xFF00E5FF) : Colors.white.withOpacity(0.3),
          ),
        );
      }),
    );
  }
}

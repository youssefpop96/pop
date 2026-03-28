import 'package:flutter/material.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';

class LuminousBackground extends StatelessWidget {
  const LuminousBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.kPrimary),
        Positioned(
          top: -100,
          right: -100,
          child: _MeshCircle(color: AppColors.kPrimaryContainer, size: 400),
        ),
        Positioned(
          bottom: -150,
          left: -100,
          child: _MeshCircle(color: AppColors.kSecondary, size: 500),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
          ),
        ),
      ],
    );
  }
}

class _MeshCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _MeshCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.6),
            color.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}

class AuthLayout extends StatelessWidget {
  final Widget child;
  final String logo;

  const AuthLayout({super.key, required this.child, this.logo = 'POP'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const LuminousBackground(),
          Column(
            children: [
              const SizedBox(height: 100),
              Center(
                child: Hero(
                  tag: 'app_logo',
                  child: Text(
                    logo,
                    style: AppTextStyles.headlineLg.copyWith(
                      color: Colors.white,
                      fontSize: 48,
                      letterSpacing: 20,
                      fontWeight: FontWeight.w900,
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
              const SizedBox(height: 64),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 56),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 40,
                        offset: const Offset(0, -10),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

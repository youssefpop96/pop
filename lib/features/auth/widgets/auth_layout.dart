import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;
  final String logo;

  const AuthLayout({super.key, required this.child, this.logo = 'PoP'});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        Center(
          child: Text(
            logo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 40),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: SingleChildScrollView(child: child),
          ),
        ),
      ],
    );
  }
}

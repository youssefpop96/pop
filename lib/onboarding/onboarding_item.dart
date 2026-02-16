import 'package:flutter/material.dart';

class OnboardingItem {
  final String title;
  final String description;
  final Color bgColor;
  final String imagePath; // Changed from IconData icon

  OnboardingItem({
    required this.title,
    required this.description,
    required this.bgColor,
    required this.imagePath,
  });
}

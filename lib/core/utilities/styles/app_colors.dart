import 'package:flutter/material.dart';

class AppColors {
  static const Color kPrimaryColor = Color(
    0xFFFB5BBD,
  ); // Pink color from before
  static const Color kOnboardingPink = Color(0xFFFDE3E0);
  static const Color kOnboardingYellow = Color(0xFFFBFDE1);
  static const Color kOnboardingPeach = Color(0xFFFFE6D3);
  static const Color kTextGrey = Colors.black54;
  static const Color kLightGreyColor = Color(
    0xFFF8F9FA,
  ); // Background grey in UI

  // Gradients for cards based on UI reference
  static const List<Color> kGradientBlue = [
    Color(0xFF0061FF),
    Color(0xFF60EFFF),
  ]; // Personal
  static const List<Color> kGradientGreen = [
    Color(0xFF1D976C),
    Color(0xFF93F9B9),
  ]; // Work
  static const List<Color> kGradientPurple = [
    Color(0xFF8E2DE2),
    Color(0xFF4A00E0),
  ]; // Study
  static const List<Color> kGradientOrange = [
    Color(0xFFF2994A),
    Color(0xFFF2C94C),
  ]; // Ideas
}

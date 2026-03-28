import 'package:flutter/material.dart';

class AppColors {
  // Luminous Ethereality Palette
  static const Color kBackground = Color(0xFFEAF9FF);
  static const Color kSurfaceLow = Color(0xFFDBF5FF);
  static const Color kSurfaceLowest = Color(0xFFFFFFFF);
  static const Color kPrimary = Color(0xFF006571);
  static const Color kPrimaryContainer = Color(0xFF00E3FD);
  static const Color kSecondary = Color(0xFF9500C8); // Cyber Purple
  static const Color kOnSurface = Color(0xFF003440);
  static const Color kOutlineVariant = Color(0xFF82B5C6);

  static const Color kTextGrey = Colors.black54;

  // Folder Identity Colors
  static const List<Color> kFolderColors = [
    Color(0xFF00E5FF), // Cyan
    Color(0xFF8E24AA), // Purple
    Color(0xFF76FF03), // Green
    Color(0xFFFF007F), // Pink
    Color(0xFFFFC107), // Yellow
  ];

  static const List<IconData> kFolderIcons = [
    Icons.folder_rounded,
    Icons.business_center_rounded,
    Icons.person_rounded,
    Icons.favorite_rounded,
    Icons.lightbulb_outline_rounded,
    Icons.check_circle_outline_rounded,
    Icons.star_rounded,
    Icons.more_horiz_rounded,
  ];

  // Signatures
  static const List<Color> kMeshGradient = [kPrimary, kPrimaryContainer];
  
  // Layout Constants
  static const double kCornerRadius = 30.0; // xl (3rem)

  // Compatibility Aliases (to be replaced)
  static const Color kPrimaryColor = kPrimary;
  static const Color kLightGreyColor = kSurfaceLow;
  static const List<Color> kGradientBlue = [kPrimary, kSecondary];
  static const List<Color> kGradientGreen = [kPrimary, Color(0xFF00E3FD)];
  static const List<Color> kGradientPurple = [kSecondary, Color(0xFF7000FF)];
  static const List<Color> kGradientOrange = [Color(0xFFFFB800), Color(0xFFFFE600)];
  static const List<Color> kGradientPink = [Color(0xFFFF00A8), Color(0xFFFF70CD)];
  static const List<Color> kGradientTeal = [Color(0xFF00FFD1), Color(0xFF0094FF)];
  static const Color kOnboardingPeach = kSurfaceLow;
}

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

  // Signatures
  static const List<Color> kMeshGradient = [kPrimary, kPrimaryContainer];
  
  // Layout Constants
  static const double kCornerRadius = 30.0; // xl (3rem)

  // Folder Visual Pools
  static const List<List<Color>> kFolderGradients = [
    [Color(0xFF6366F1), Color(0xFF8B5CF6)], // Indigo
    [Color(0xFF10B981), Color(0xFF34D399)], // Emerald
    [Color(0xFF8B5CF6), Color(0xFFC084FC)], // Violet
    [Color(0xFFF59E0B), Color(0xFFFCD34D)], // Amber
    [Color(0xFFEC4899), Color(0xFFF472B6)], // Pink
    [Color(0xFF14B8A6), Color(0xFF5EEAD4)], // Teal
  ];

  static const List<IconData> kFolderIcons = [
    Icons.folder,
    Icons.business_center,
    Icons.videocam,
    Icons.home,
    Icons.description,
    Icons.stars,
  ];

  // Compatibility Aliases
  static const Color kPrimaryColor = kPrimary;
  static const Color kLightGreyColor = kSurfaceLow;
  static const List<Color> kGradientBlue = [Color(0xFF6366F1), Color(0xFF8B5CF6)];
  static const List<Color> kGradientGreen = [Color(0xFF10B981), Color(0xFF34D399)];
  static const List<Color> kGradientPurple = [Color(0xFF8B5CF6), Color(0xFFC084FC)];
  static const List<Color> kGradientOrange = [Color(0xFFF59E0B), Color(0xFFFCD34D)];
  static const List<Color> kGradientPink = [Color(0xFFEC4899), Color(0xFFF472B6)];
  static const List<Color> kGradientTeal = [Color(0xFF14B8A6), Color(0xFF5EEAD4)];
  static const Color kOnboardingPeach = kSurfaceLow;
}

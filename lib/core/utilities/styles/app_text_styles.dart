import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Luminous Typography System
  static TextStyle displayLg = GoogleFonts.spaceGrotesk(
    fontSize: 56, // 3.5rem
    fontWeight: FontWeight.bold,
    letterSpacing: -1.12, // -0.02em
    color: AppColors.kOnSurface,
    height: 1.1,
  );

  static TextStyle displayMd = GoogleFonts.spaceGrotesk(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.kOnSurface,
    height: 1.2,
  );

  static TextStyle headlineLg = GoogleFonts.spaceGrotesk(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.kOnSurface,
    height: 1.2,
  );

  static TextStyle headlineMd = GoogleFonts.spaceGrotesk(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.kOnSurface,
  );

  static TextStyle headlineSm = GoogleFonts.spaceGrotesk(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.kOnSurface,
  );

  static TextStyle bodyLg = GoogleFonts.inter(
    fontSize: 18,
    color: AppColors.kOnSurface.withValues(alpha: 0.8),
    height: 1.6,
  );

  static TextStyle bodyMd = GoogleFonts.inter(
    fontSize: 14, // 0.875rem
    color: AppColors.kOnSurface.withValues(alpha: 0.8),
    height: 1.6,
  );

  static TextStyle labelMd = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.kSecondary,
    letterSpacing: 0.5,
  );

  // Compatibility Aliases (to be replaced)
  static TextStyle get title64Black900 => displayLg.copyWith(fontSize: 64);
  static TextStyle get title48BlackBold => displayLg.copyWith(fontSize: 48);
  static TextStyle get title32White900 => displayMd.copyWith(color: Colors.white, fontSize: 32);
  static TextStyle get title28Black87Bold => displayMd.copyWith(fontSize: 28);
  static TextStyle get title24BlackBold => headlineMd;
  static TextStyle get title18Black500 => bodyMd.copyWith(fontSize: 18, color: AppColors.kPrimary, fontWeight: FontWeight.w500);
  static TextStyle get title16GreyW500 => bodyMd.copyWith(fontSize: 16, color: Colors.grey);
  static TextStyle get title14Black600 => bodyMd.copyWith(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.kOnSurface);
  static TextStyle get body18Black87 => bodyMd.copyWith(fontSize: 18);
}

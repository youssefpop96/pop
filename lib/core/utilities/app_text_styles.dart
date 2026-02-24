import 'package:flutter/material.dart';
import 'styles/app_colors.dart';

class AppTextStyles {
  static const TextStyle title64Black900 = TextStyle(
    fontSize: 64,
    fontWeight: FontWeight.w900,
    height: 1.0,
    color: AppColors.kPrimaryColor,
    letterSpacing: -1,
  );

  static const TextStyle title32White900 = TextStyle(
    color: Colors.white,
    fontSize: 32,
    fontWeight: FontWeight.w900,
    letterSpacing: 2,
  );

  static const TextStyle title28Black87Bold = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle title24BlackBold = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle title18Black500 = TextStyle(
    fontSize: 18,
    height: 1.3,
    fontWeight: FontWeight.w500,
    color: AppColors.kPrimaryColor,
  );

  static const TextStyle title16GreyW500 = TextStyle(
    color: Colors.grey,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle title14Black600 = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );
}

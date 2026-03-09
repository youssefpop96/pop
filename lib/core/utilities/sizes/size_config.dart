import 'package:flutter/widgets.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static double? defaultSize;
  static Orientation? orientation;
  static late double horizontalBlock;
  static late double verticalBlock;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;

    // Initialize block units for responsive design
    horizontalBlock = screenWidth / 100;
    verticalBlock = screenHeight / 100;
  }

  static double get width => screenWidth;
  static double get height => screenHeight;
}

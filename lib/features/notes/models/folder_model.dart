import 'package:flutter/material.dart';

class FolderModel {
  final String title;
  final int notesCount;
  final IconData icon;
  final List<Color> gradientColors;

  FolderModel({
    required this.title,
    required this.notesCount,
    required this.icon,
    required this.gradientColors,
  });
}

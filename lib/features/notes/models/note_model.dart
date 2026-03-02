import 'package:flutter/material.dart';

class NoteModel {
  final String title;
  final String folder;
  final String time;
  final Color categoryColor;
  final IconData icon;

  NoteModel({
    required this.title,
    required this.folder,
    required this.time,
    required this.categoryColor,
    required this.icon,
  });
}

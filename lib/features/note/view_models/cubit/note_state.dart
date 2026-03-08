import 'package:flutter/material.dart';
import '../../../../core/models/folder_model.dart';
import '../../../../core/models/note_model.dart';

@immutable
abstract class NoteState {}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NoteSuccess extends NoteState {
  final List<FolderModel> folders;
  final List<NoteModel> recentNotes;
  final List<NoteModel>? folderNotes;

  NoteSuccess({
    required this.folders,
    required this.recentNotes,
    this.folderNotes,
  });
}

class NoteFailure extends NoteState {
  final String errMessage;
  NoteFailure({required this.errMessage});
}

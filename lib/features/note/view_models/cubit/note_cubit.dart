import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/folder_model.dart';
import '../../../../core/models/note_model.dart';
import '../../../../core/repositories/notes_repository.dart';
import 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final NotesRepository _repository;

  NoteCubit(this._repository) : super(NoteInitial());

  List<FolderModel> _folders = [];
  List<NoteModel> _recentNotes = [];

  Future<void> fetchHomeData() async {
    emit(NoteLoading());
    try {
      _folders = await _repository.getFolders();

      // If no folders exist, create default ones for a better first-time experience
      if (_folders.isEmpty) {
        await _ensureDefaultFoldersExist();
        _folders = await _repository.getFolders();
      }

      _recentNotes = await _repository.getNotes();
      emit(NoteSuccess(folders: _folders, recentNotes: _recentNotes));
    } catch (e) {
      emit(NoteFailure(errMessage: e.toString()));
    }
  }

  Future<void> _ensureDefaultFoldersExist() async {
    final defaultFolders = [
      {'name': 'Personal', 'color_index': 0, 'icon_name': 'icon_2'},
      {'name': 'Work', 'color_index': 1, 'icon_name': 'icon_1'},
      {'name': 'Study', 'color_index': 2, 'icon_name': 'icon_4'},
      {'name': 'Ideas', 'color_index': 3, 'icon_name': 'icon_4'},
    ];

    for (var f in defaultFolders) {
      await _repository.createFolder(
        FolderModel(
          id: '',
          userId: '', // Repository handles session ID
          name: f['name'] as String,
          colorIndex: f['color_index'] as int,
          iconName: f['icon_name'] as String,
          createdAt: DateTime.now(),
        ),
      );
    }
  }

  Future<void> fetchFolderNotes(String folderId) async {
    // We emit loading if we don't have notes yet to show a spinner in the folder screen
    emit(NoteLoading());
    try {
      final folderNotes = await _repository.getNotes(folderId: folderId);
      emit(
        NoteSuccess(
          folders: _folders,
          recentNotes: _recentNotes,
          folderNotes: folderNotes,
        ),
      );
    } catch (e) {
      emit(NoteFailure(errMessage: e.toString()));
    }
  }

  Future<void> addNote({
    required String title,
    required String content,
    required String folderId,
    List<String> tags = const [],
    List<String> images = const [],
  }) async {
    try {
      await _repository.saveNote(
        NoteModel(
          id: '',
          userId: '',
          folderId: folderId,
          title: title,
          content: content,
          tags: tags,
          images: images,
          createdAt: DateTime.now(),
        ),
      );

      await fetchHomeData();
    } catch (e) {
      emit(NoteFailure(errMessage: e.toString()));
    }
  }

  Future<void> updateNote(NoteModel note) async {
    try {
      await _repository.saveNote(note);
      await fetchHomeData();
    } catch (e) {
      emit(NoteFailure(errMessage: e.toString()));
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await _repository.deleteNote(noteId);
      await fetchHomeData();
    } catch (e) {
      emit(NoteFailure(errMessage: e.toString()));
    }
  }

  Future<void> createFolder({
    required String name,
    required int colorIndex,
    String? iconName,
  }) async {
    try {
      await _repository.createFolder(
        FolderModel(
          id: '',
          userId: '',
          name: name,
          colorIndex: colorIndex,
          iconName: iconName,
          createdAt: DateTime.now(),
        ),
      );
      await fetchHomeData();
    } catch (e) {
      emit(NoteFailure(errMessage: e.toString()));
    }
  }

  void searchNotes(String query) {
    if (query.isEmpty) {
      emit(NoteSuccess(folders: _folders, recentNotes: _recentNotes));
    } else {
      final filtered = _recentNotes.where((note) {
        return note.title.toLowerCase().contains(query.toLowerCase()) ||
            note.content.toLowerCase().contains(query.toLowerCase());
      }).toList();
      emit(NoteSuccess(folders: _folders, recentNotes: filtered));
    }
  }

  Future<String> uploadImage(File file) async {
    try {
      final extension = file.path.contains('.')
          ? file.path.split('.').last
          : 'jpg';
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';
      return await _repository.uploadImage(file, fileName);
    } catch (e) {
      throw Exception('Cubit Upload failed: $e');
    }
  }
}

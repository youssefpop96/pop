import 'package:pop/core/models/folder_model.dart';
import 'package:pop/core/models/note_model.dart';
import 'package:pop/core/services/database_service.dart';

/// Repository class that abstracts the data layer for notes and folders.
/// It acts as a single point of truth for managing application data.
class NotesRepository {
  final DatabaseService _dbService;

  NotesRepository(this._dbService);

  /// Fetches all folders associated with the current user.
  Future<List<FolderModel>> getFolders() async {
    return await _dbService.getFolders();
  }

  /// Fetches notes, optionally filtered by [folderId].
  Future<List<NoteModel>> getNotes({String? folderId}) async {
    return await _dbService.getNotes(folderId: folderId);
  }

  /// Saves a note (creates if new, updates if existing).
  Future<void> saveNote(NoteModel note) async {
    if (note.id.isEmpty || note.id == '0') {
      await _dbService.createNote(note);
    } else {
      await _dbService.updateNote(note.id, note.toJson());
    }
  }

  /// Creates a new folder.
  Future<void> createFolder(FolderModel folder) async {
    await _dbService.createFolder(folder);
  }

  /// Deletes a specific note by its [id].
  Future<void> deleteNote(String id) async {
    await _dbService.deleteNote(id);
  }
}

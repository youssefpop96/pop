import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/folder_model.dart';
import '../models/note_model.dart';

class DatabaseService {
  final _supabase = Supabase.instance.client;

  // --- Folders ---

  Future<List<FolderModel>> getFolders() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabase
        .from('folders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => FolderModel.fromJson(json))
        .toList();
  }

  Future<void> createFolder(FolderModel folder) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final data = folder.toJson();
    data['user_id'] = userId;
    await _supabase.from('folders').insert(data);
  }

  // --- Notes ---

  Future<List<NoteModel>> getNotes({String? folderId}) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    var query = _supabase.from('notes').select().eq('user_id', userId);

    if (folderId != null) {
      query = query.eq('folder_id', folderId);
    }

    final response = await query.order('created_at', ascending: false);

    return (response as List).map((json) => NoteModel.fromJson(json)).toList();
  }

  Future<void> createNote(NoteModel note) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final data = note.toJson();
    data['user_id'] = userId;
    await _supabase.from('notes').insert(data);
  }

  Future<void> deleteNote(String noteId) async {
    await _supabase.from('notes').delete().eq('id', noteId);
  }

  Future<void> updateNote(String noteId, Map<String, dynamic> updates) async {
    await _supabase.from('notes').update(updates).eq('id', noteId);
  }
}

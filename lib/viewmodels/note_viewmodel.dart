import 'package:lesson53_todo/models/note.dart';
import 'package:lesson53_todo/services/note_local_database.dart';

class NotesController {
  final _notesDatabase = NotesDatabase();

  List<Note> _notesList = [];

  Future<List<Note>> get notesList async {
    _notesList = await _notesDatabase.getNotes();

    return [..._notesList];
  }

  Future<void> addNote(
    String title,
    String subtitle,
    String time,
  ) async {
    await _notesDatabase.addNotes({
      'title': title,
      'subtitle': subtitle,
      'time': time.toString(),
    });
  }

  Future<void> editNote(
    int id,
    String title,
    String subtitle,
    String time,
  ) async {
    await _notesDatabase.editNotes(id, {
      'title': title,
      'subtitle': subtitle,
      'time': time.toString(),
    });
  }

  Future<void> deleteNote(int id) async {
    await _notesDatabase.deleteNote(id);
  }
}

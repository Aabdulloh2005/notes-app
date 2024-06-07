import 'package:lesson53_todo/services/local_database.dart';
import 'package:lesson53_todo/models/note.dart';

class NotesDatabase {
  final _localDatabse = LocalDatabase();
  final String _tableName = 'notes';

  Future<List<Note>> getNotes() async {
    final db = await _localDatabse.database;

    final rows = await db.query(_tableName);

    List<Note> fromData = [];

    for (var row in rows) {
      fromData.add(
        Note.fromMap(row),
      );
    }

    return fromData;
  }

  Future<void> addNotes(Map<String, dynamic> noteData) async {
    final db = await _localDatabse.database;

    await db.insert(_tableName, noteData);
  }

  Future<void> editNotes(int id, Map<String, dynamic> noteData) async {
    final db = await _localDatabse.database;
    await db.update(
      _tableName,
      noteData,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await _localDatabse.database;

    await db.delete(
      _tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}

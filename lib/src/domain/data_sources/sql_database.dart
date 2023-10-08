import 'package:sqflite/sqlite_api.dart';

import '../entities/note_entity.dart';
import 'note_local_data_source.dart';

class SqlDatabase implements NoteLocalDataSource {
  final Database database;

  SqlDatabase(this.database);

  @override
  Future<void> addNoteToDatabase(NoteEntity note) async {
    final db = database;
    await db.insert(
      'notes',
      note.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteNoteFromDatabase(NoteEntity note) async {
    final db = database;
    await db.delete(
      'notes',
      where: 'dateCreated = ?',
      whereArgs: [note.dateCreated.toIso8601String()],
    );
  }

  @override
  Future<void> editNoteToDatabase(NoteEntity note) async {
    final db = database;
    await db.update(
      'notes',
      note.toJson(),
      where: 'dateCreated = ?',
      whereArgs: [note.dateCreated.toIso8601String()],
    );
  }

  @override
  Future<List<NoteEntity>> getAllNotesFromDatabase() async {
    final db = database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(
      maps.length,
      (i) => NoteEntity.fromJson(maps[i]),
    );
  }
}

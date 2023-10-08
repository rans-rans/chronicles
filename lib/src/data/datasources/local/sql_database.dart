import 'package:sqflite/sqflite.dart';

import 'local_data_source.dart';
import '/src/data/models/note_model.dart';

class LocalDataSourceImpl implements LocalDataSource {
  final Database database;

  LocalDataSourceImpl(this.database);

  @override
  Future<void> addNoteToLocalDatabase(NoteModel note) async {
    final db = database;
    await db.insert(
      'notes',
      note.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteNoteFromLocalDatabase(NoteModel note) async {
    final db = database;
    await db.delete(
      'notes',
      where: 'dateCreated = ?',
      whereArgs: [note.dateCreated.toIso8601String()],
    );
  }

  @override
  Future<void> editNoteToLocalDatabase(NoteModel note) async {
    final db = database;
    await db.update(
      'notes',
      note.toJson(),
      where: 'dateCreated = ?',
      whereArgs: [note.dateCreated.toIso8601String()],
    );
  }

  @override
  Future<List<NoteModel>> getNotesFromLocalDatabase() async {
    final db = database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(
      maps.length,
      (i) => NoteModel.fromJson(maps[i]),
    );
  }
}

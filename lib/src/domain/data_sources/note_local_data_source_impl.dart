import 'package:clean_architecture_notebook/src/domain/data_sources/note_local_data_source.dart';

import 'sql_database.dart';
import '/src/domain/entities/note_entity.dart';

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  final SqlDatabase dataSource;
  NoteLocalDataSourceImpl({
    required this.dataSource,
  });

  @override
  Future<void> addNoteToDatabase(NoteEntity note) async {
    await dataSource.addNoteToDatabase(note);
  }

  @override
  Future<void> deleteNoteFromDatabase(NoteEntity note) async {
    await dataSource.deleteNoteFromDatabase(note);
  }

  @override
  Future<void> editNoteToDatabase(NoteEntity note) async {
    await dataSource.editNoteToDatabase(note);
  }

  @override
  Future<List<NoteEntity>> getAllNotesFromDatabase() async {
    return dataSource.getAllNotesFromDatabase();
  }
}

import '/src/domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/data_sources/note_local_data_source.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource dataSource;

  NoteRepositoryImpl(this.dataSource);

  @override
  Future<void> addNote(NoteEntity note) async {
    await dataSource.addNoteToDatabase(note);
  }

  @override
  Future<void> deleteNote(NoteEntity note) async {
    await dataSource.deleteNoteFromDatabase(note);
  }

  @override
  Future<void> editNote(NoteEntity note) async {
    await dataSource.editNoteToDatabase(note);
  }

  @override
  Future<List<NoteEntity>> getAllNotes() async {
    return dataSource.getAllNotesFromDatabase();
  }
}

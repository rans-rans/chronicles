import '../entities/note_entity.dart';

abstract class NoteLocalDataSource {
  Future<void> addNoteToDatabase(NoteEntity note);
  Future<void> editNoteToDatabase(NoteEntity note);
  Future<void> deleteNoteFromDatabase(NoteEntity note);
  Future<List<NoteEntity>> getAllNotesFromDatabase();
}

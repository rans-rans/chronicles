import '../entities/note_entity.dart';

abstract class NoteRepository {
  Future<void> addNote(NoteEntity note);
  Future<void> deleteNote(NoteEntity note);
  Future<void> editNote(NoteEntity note);
  Future<List<NoteEntity>> getAllNotes();
}

import '../../models/note_model.dart';

abstract class LocalDataSource {
  Future<void> addNoteToLocalDatabase(NoteModel note);
  Future<void> deleteNoteFromLocalDatabase(NoteModel note);
  Future<void> editNoteToLocalDatabase(NoteModel note);
  Future<List<NoteModel>> getNotesFromLocalDatabase();
}

import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class AddNoteUseCase {
  final NoteRepository noteRepository;
  AddNoteUseCase(this.noteRepository);

  Future<void> execute(NoteEntity note) async {
    await noteRepository.addNote(note);
  }
}

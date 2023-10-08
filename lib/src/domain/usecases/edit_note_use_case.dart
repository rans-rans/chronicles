import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class EditNoteUseCase {
  final NoteRepository noteRepository;
  EditNoteUseCase(this.noteRepository);

  Future<void> execute(NoteEntity note) async {
    await noteRepository.editNote(note);
  }
}

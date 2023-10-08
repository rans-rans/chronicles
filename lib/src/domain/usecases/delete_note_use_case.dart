import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class DeleteNoteUseCase {
  final NoteRepository noteRepository;
  DeleteNoteUseCase(this.noteRepository);

  Future<void> execute(NoteEntity note) async {
    await noteRepository.deleteNote(note);
  }
}

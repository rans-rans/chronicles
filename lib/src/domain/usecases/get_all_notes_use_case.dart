import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class GetAllNotesUseCase {
  final NoteRepository noteRepository;
  GetAllNotesUseCase(this.noteRepository);

  Future<List<NoteEntity>> execute() async {
    return await noteRepository.getAllNotes();
  }
}

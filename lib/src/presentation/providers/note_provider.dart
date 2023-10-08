import 'package:flutter/material.dart' show BuildContext, ChangeNotifier;
import 'package:provider/provider.dart' show Provider;

import '../../domain/entities/note_entity.dart';
import '/src/domain/usecases/add_note_use_case.dart';
import '/src/domain/usecases/delete_note_use_case.dart';
import '/src/domain/usecases/edit_note_use_case.dart';
import '/src/domain/usecases/get_all_notes_use_case.dart';

class NoteProvider extends ChangeNotifier {
  final AddNoteUseCase addNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;
  final EditNoteUseCase editNoteUseCase;
  final GetAllNotesUseCase getAllNotesUseCase;

  NoteProvider({
    required this.addNoteUseCase,
    required this.deleteNoteUseCase,
    required this.editNoteUseCase,
    required this.getAllNotesUseCase,
  });

  static NoteProvider of(BuildContext context, {listen = true}) {
    return Provider.of<NoteProvider>(context, listen: listen);
  }

  List<NoteEntity> _allNotes = [];

  List<NoteEntity> get allNotes => _allNotes;

  NoteEntity recent() {
    List<NoteEntity> notes = [..._allNotes];
    for (var pass = 0; pass < notes.length - 1; pass++) {
      for (var comp = 0; comp < notes.length - 1; comp++) {
        if (notes[comp].dateModified.isBefore(notes[comp + 1].dateModified)) _interchagePosition(notes, comp);
      }
    }
    return notes.first;
  }

  void _interchagePosition(List list, int comp) {
    var temp = list[comp + 1];
    list[comp + 1] = list[comp];
    list[comp] = temp;
  }

  Future<void> getAllNotesFromDatabase() async {
    _allNotes = await getAllNotesUseCase.execute();
  }

  Future<void> addNoteToDatabase(NoteEntity note) async {
    // await _dataSource.addNoteToDatabase(note);
    await addNoteUseCase.execute(note);
    _allNotes.add(note);
    notifyListeners();
  }

  Future<void> editNoteInDatabase(NoteEntity note) async {
    // await _dataSource.editNoteToDatabase(note);
    await editNoteUseCase.execute(note);
    final index = _allNotes.indexWhere((n) => n.dateCreated == note.dateCreated);
    if (index != -1) {
      _allNotes[index] = note;
      notifyListeners();
    }
  }

  Future<void> deleteNoteInDatabase(NoteEntity note) async {
    // await _dataSource.deleteNoteFromDatabase(note);
    await deleteNoteUseCase.execute(note);
    _allNotes.removeWhere((n) => n.dateCreated == note.dateCreated);
    notifyListeners();
  }
}

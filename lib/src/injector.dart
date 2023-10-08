import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqlite_api.dart';

import 'presentation/providers/note_provider.dart';
import '/src/data/repositories/note_repo_impl.dart';

import 'domain/data_sources/sql_database.dart';
import 'domain/data_sources/note_local_data_source_impl.dart';

import '/src/domain/usecases/add_note_use_case.dart';
import '/src/domain/usecases/delete_note_use_case.dart';
import '/src/domain/usecases/edit_note_use_case.dart';
import '/src/domain/usecases/get_all_notes_use_case.dart';

class Injector extends StatelessWidget {
  final Widget widget;
  final Database database;
  const Injector(this.widget, this.database, {super.key});

  @override
  Widget build(BuildContext context) {
    final noteRepository = NoteRepositoryImpl(
      NoteLocalDataSourceImpl(dataSource: SqlDatabase(database)),
    );
    return ChangeNotifierProvider(
      child: widget,
      create: (context) => NoteProvider(
        addNoteUseCase: AddNoteUseCase(noteRepository),
        deleteNoteUseCase: DeleteNoteUseCase(noteRepository),
        editNoteUseCase: EditNoteUseCase(noteRepository),
        getAllNotesUseCase: GetAllNotesUseCase(noteRepository),
      ),
    );
  }
}

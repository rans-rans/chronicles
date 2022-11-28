// ignore_for_file: curly_braces_in_flow_control_structures, prefer_final_fields

import "package:flutter/material.dart";
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:notebook/providers/note_task.dart';
import 'package:notebook/providers/undo_redo.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../providers/app_settings.dart';

class CreatenotePage extends StatefulWidget {
  static const routeName = "/create-note";
  final Note? note;
  const CreatenotePage({required this.note, super.key});

  @override
  State<CreatenotePage> createState() => _CreatenotePageState();
}

class _CreatenotePageState extends State<CreatenotePage>
    with WidgetsBindingObserver {
  final _titleText = TextEditingController();
  final _contentText = TextEditingController();
  final _titleFocus = FocusNode();
  final _contentFocus = FocusNode();
  bool _isSaving = false;
  String counter = "";
  List<String> _undoStack = [];
  List<String> _redoStack = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (widget.note != null) {
      _titleText.text = widget.note!.title;
      _contentText.text = widget.note!.contents;
    } else {
      _titleText.text = "Untitled";
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final fxn = Provider.of<NoteTask>(context, listen: false);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    if (state == AppLifecycleState.paused) {
      if (widget.note != null) {
        fxn.saveNote(
          Note(
            title: _titleText.text.isEmpty ? "Untitled" : _titleText.text,
            contents: _contentText.text,
            dateCreated: widget.note!.dateCreated,
            dateModified: DateTime.now(),
          ),
          false,
        );
      } else {
        fxn.saveNote(
          Note(
            title: _titleText.text.isEmpty ? "Untitled" : _titleText.text,
            contents: _contentText.text,
            dateCreated: DateTime.now(),
            dateModified: DateTime.now(),
          ),
          true,
        );
      }
      showToast(
        "Saved",
        context: context,
        animation: StyledToastAnimation.scale,
        dismissOtherToast: true,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _titleText.dispose();
    _contentText.dispose();
    _titleFocus.dispose();
    _contentFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fxn = Provider.of<NoteTask>(context, listen: false);
    final settings = Provider.of<AppSettings>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        if (widget.note != null)
          await fxn.saveNote(
              Note(
                title: _titleText.text.isEmpty ? "Untitled" : _titleText.text,
                contents: _contentText.text,
                dateCreated: widget.note!.dateCreated,
                dateModified: DateTime.now(),
              ),
              false);
        if (widget.note != null)
          showToast(
            "Saved",
            context: context,
            animation: StyledToastAnimation.scale,
            dismissOtherToast: true,
          );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notepad"),
          actions: [
            TextButton(
              child: const Text("Save", style: TextStyle(color: Colors.white)),
              onPressed: () {
                if (widget.note == null)
                  fxn.saveNote(
                    Note(
                      title: _titleText.text.isEmpty
                          ? "Untitled"
                          : _titleText.text,
                      contents: _contentText.text,
                      dateCreated: DateTime.now(),
                      dateModified: DateTime.now(),
                    ),
                    true,
                  );
                else
                  fxn.saveNote(
                    Note(
                      title: _titleText.text.isEmpty
                          ? "Untitled"
                          : _titleText.text,
                      contents: _contentText.text,
                      dateCreated: widget.note!.dateCreated,
                      dateModified: DateTime.now(),
                    ),
                    false,
                  );
                showToast(
                  "Saved",
                  context: context,
                  animation: StyledToastAnimation.scale,
                  dismissOtherToast: true,
                );
                Navigator.of(context).pop();
              },
            ),
            IconButton(
              icon: const Icon(Icons.undo),
              onPressed: () {
                UndoRedo().undo(
                  undoStack: _undoStack,
                  redoStack: _redoStack,
                  text: _contentText.text,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.redo),
              onPressed: () {
                UndoRedo().redo(
                  undoStack: _undoStack,
                  redoStack: _redoStack,
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: widget.note == null
                  ? null
                  : () async => await fxn
                      .addToTrash(
                        Note(
                          title: _titleText.text.isEmpty
                              ? "Untitled"
                              : _titleText.text,
                          contents: _contentText.text,
                          dateCreated: widget.note!.dateCreated,
                          dateModified: DateTime.now(),
                        ),
                      )
                      .then((_) => Navigator.of(context).pop()),
            ),
          ],
        ),
        body: _isSaving
            ? const Center(child: CircularProgressIndicator.adaptive())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text("Title:  "),
                        Expanded(
                          child: TextField(
                            controller: _titleText,
                          ),
                        ),
                      ],
                    ),
                    //insert body here
                    Expanded(
                        child: TextField(
                      controller: _contentText,
                      expands: true,
                      maxLines: null,
                      style: TextStyle(
                        fontFamily: settings.myFont.toString().substring(7),
                        fontSize:
                            settings.myFont.toString().substring(7) != "Roboto"
                                ? 20
                                : 16,
                        fontWeight:
                            settings.myFont.toString().substring(7) != "Roboto"
                                ? FontWeight.w600
                                : FontWeight.w400,
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) return;

                        if (value.characters.last == " ") {
                          final word = UndoRedo().addToUndoStack(
                            letter: value.characters.last,
                            counter: counter,
                            undoStack: _undoStack,
                          );
                          _undoStack.add(word);
                        }
                      },
                    )),
                  ],
                ),
              ),
      ),
    );
  }
}

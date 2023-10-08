import "package:flutter/material.dart";
import "package:provider/provider.dart" show Provider;
import "package:flutter/services.dart" show MethodChannel;
import 'package:flutter_quill/flutter_quill.dart' as quill show QuillController, QuillToolbar, QuillEditor;

import '../../domain/entities/note_entity.dart';
import "../providers/note_provider.dart";
import "../widgets/native_widgets.dart";

class CreateNotePage extends StatefulWidget {
  final NoteEntity? note;
  const CreateNotePage({required this.note, super.key});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> with WidgetsBindingObserver {
  final _titleText = TextEditingController();
  final quillController = quill.QuillController.basic();
  final _titleFocus = FocusNode();
  final _contentFocus = FocusNode();

  late NoteProvider _provider;

  final methodChannel = const MethodChannel('rans_innovations/notebook');

  NoteEntity note = NoteEntity(
    title: "",
    body: "",
    dateCreated: DateTime.now(),
    dateModified: DateTime.now(),
  );

  Future<void> saveNote() async {
    note.title = _titleText.text.isEmpty ? "Untitled" : _titleText.text;
    note.body = quillController.plainTextEditingValue.text;
    note.dateModified = DateTime.now();
    note.dateCreated = widget.note == null ? DateTime.now() : widget.note!.dateCreated;

    if (widget.note == null) {
      _provider.addNoteToDatabase(note);
    } else {
      _provider.editNoteInDatabase(note);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _provider = Provider.of<NoteProvider>(context, listen: false);
    if (widget.note != null) {
      final note = widget.note!;
      _titleText.text = note.title;
      quillController.document.insert(0, note.body);
    } else {
      _titleText.text = "Untitled";
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive || state == AppLifecycleState.detached) {
      return;
    }

    if (state == AppLifecycleState.paused) {
      saveNote();
      showToast(
        message: 'Note saved',
        channel: methodChannel,
      );
    }
    if (state == AppLifecycleState.resumed) {}
  }

  @override
  void dispose() {
    super.dispose();
    _titleText.dispose();
    quillController.dispose();
    _titleFocus.dispose();
    _contentFocus.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Future.delayed(
          const Duration(seconds: 0),
          () async => await saveNote(),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notepad"),
          actions: [
            TextButton(
              child: const Text("Save", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                await saveNote();
                if (mounted) {
                  showToast(
                    message: "Saved",
                    channel: methodChannel,
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: widget.note != null ? Colors.red : Colors.grey,
                ),
                onPressed: switch (widget.note == null) {
                  true => null,
                  false => () async {
                      await _provider
                          .deleteNoteInDatabase(widget.note!)
                          .then((_) => Navigator.of(context).pop(true));
                    }
                }),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    const Text("Title:  "),
                    Expanded(
                      child: TextField(
                        controller: _titleText,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: quill.QuillToolbar.basic(
                  showFontFamily: false,
                  showBoldButton: false,
                  showStrikeThrough: false,
                  showItalicButton: false,
                  showUnderLineButton: false,
                  showColorButton: false,
                  showSubscript: false,
                  showSuperscript: false,
                  showQuote: false,
                  showSearchButton: false,
                  showSmallButton: false,
                  showUndo: true,
                  showRedo: true,
                  controller: quillController,
                  showCodeBlock: false,
                  showIndent: false,
                  showBackgroundColorButton: false,
                  showDirection: false,
                  showDividers: false,
                  showLeftAlignment: false,
                  showCenterAlignment: false,
                  showRightAlignment: false,
                  showJustifyAlignment: false,
                  showHeaderStyle: false,
                  showListCheck: false,
                  showListBullets: false,
                  showLink: false,
                  showFontSize: false,
                  showAlignmentButtons: false,
                  showListNumbers: false,
                  showInlineCode: false,
                  showClearFormat: false,
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                  ),
                  child: quill.QuillEditor.basic(
                    autoFocus: false,
                    controller: quillController,
                    readOnly: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

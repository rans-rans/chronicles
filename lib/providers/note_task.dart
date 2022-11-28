// ignore_for_file: prefer_final_fields, curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notebook/models/note.dart';
import 'package:notebook/pages/settings_page.dart';
// import 'package:notebook/providers/shared_preference_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteTask with ChangeNotifier {
  List<Note> _notes = [];
  List<Note> _trash = [];

  List<Note> get notes => _notes;

  List<Note> get trash => _trash;

  Note recent() {
    List<Note> notes = _notes.sublist(0);
    for (var pass = 0; pass < notes.length - 1; pass++) {
      for (var comp = 0; comp < notes.length - 1; comp++) {
        if (notes[comp].dateModified.isBefore(notes[comp + 1].dateModified))
          interchagePosition(notes, comp);
      }
    }
    return notes.first;
  }

  List<Note> sortedNotes(SortingOrder order) {
    List<Note> notes = _notes.sublist(0);
    for (var pass = 0; pass < notes.length - 1; pass++) {
      for (var comp = 0; comp < notes.length - 1; comp++) {
        //title in ascending order
        if (order == SortingOrder.titleAscending) {
          if (notes[comp].title.compareTo(notes[comp + 1].title) > 0)
            interchagePosition(notes, comp);
        }
        //title in descending order
        else if (order == SortingOrder.titleDescending) {
          if (notes[comp].title.compareTo(notes[comp + 1].title) <= 0)
            interchagePosition(notes, comp);
        }
        // date created in ascending/latest order
        else if (order == SortingOrder.dateCreatedAscending) {
          if (notes[comp].dateCreated.isBefore(notes[comp + 1].dateCreated))
            interchagePosition(notes, comp);
        }
        //date created in descending order/oldest first
        else if (order == SortingOrder.dateCreatedDescending) {
          if (notes[comp].dateCreated.isAfter(notes[comp + 1].dateCreated))
            interchagePosition(notes, comp);
        }
        //date modified in ascending/latest order
        else if (order == SortingOrder.dateModifiedAscending) {
          if (notes[comp].dateModified.isBefore(notes[comp + 1].dateModified))
            interchagePosition(notes, comp);
        }
        // date modified in descending/oldest first
        else {
          if (notes[comp].dateModified.isAfter(notes[comp + 1].dateModified))
            interchagePosition(notes, comp);
        }
      }
    }
    return notes;
  }

  void interchagePosition(List list, int comp) {
    var temp = list[comp + 1];
    list[comp + 1] = list[comp];
    list[comp] = temp;
  }

  Future<void> saveNote(Note note, bool isNew) async {
    if (isNew) {
      _notes.add(note);
    } else {
      final index = _notes
          .indexWhere((element) => element.dateCreated == note.dateCreated);
      _notes[index] = Note(
        title: note.title,
        contents: note.contents,
        dateCreated: note.dateCreated,
        dateModified: note.dateModified,
      );
    }
    notifyListeners();
    Map data = {
      "title": note.title,
      "contents": note.contents,
      "date-created": note.dateCreated.toIso8601String(),
      "date-modified": note.dateCreated.toIso8601String(),
    };
    String encoded = json.encode(data);
    final shared = await SharedPreferences.getInstance();
    await shared.setString(
        "note:${note.dateCreated.toIso8601String()}", encoded);
  }

  Future<void> addToTrash(Note note) async {
    _trash.add(note);
    _notes.removeWhere((element) => element.dateCreated == note.dateCreated);
    notifyListeners();
    final shared = await SharedPreferences.getInstance();
    Map data = {
      "title": note.title,
      "contents": note.contents,
      "date-created": note.dateCreated.toIso8601String(),
      "date-modified": note.dateCreated.toIso8601String(),
    };
    String encoded = json.encode(data);
    await shared.remove("note:${note.dateCreated.toIso8601String()}");
    await shared.setString(
        "trash:${note.dateCreated.toIso8601String()}", encoded);
  }

  Future<void> addBackToNotes(Note note) async {
    await saveNote(note, true);
    _trash.removeWhere((element) => element.dateCreated == note.dateCreated);
    notifyListeners();
    final shared = await SharedPreferences.getInstance();
    await shared.remove("trash:${note.dateCreated.toIso8601String()}");
  }

  Future<void> deleteFromTrash(Note note) async {
    final shared = await SharedPreferences.getInstance();
    await shared.remove("trash:${note.dateCreated.toIso8601String()}");
    _trash.removeWhere((element) => element.dateCreated == note.dateCreated);
    notifyListeners();
  }

  Future<void> getNotesFromStorage() async {
    final shared = await SharedPreferences.getInstance();
    final keys = shared.getKeys();
    for (var element in keys) {
      if (element.startsWith("note")) {
        final encoded = shared.getString(element);
        final decoded = json.decode(encoded.toString()) as Map;
        final note = Note(
          title: decoded["title"],
          contents: decoded["contents"],
          dateCreated: DateTime.parse(decoded["date-created"]),
          dateModified: DateTime.parse(decoded["date-modified"]),
        );
        _notes.add(note);
      } else if (element.startsWith("trash")) {
        final encoded = shared.getString(element);
        final decoded = json.decode(encoded.toString()) as Map;
        final note = Note(
          title: decoded["title"],
          contents: decoded["contents"],
          dateCreated: DateTime.parse(decoded["date-created"]),
          dateModified: DateTime.parse(decoded["date-modified"]),
        );
        _trash.add(note);
      }
    }
  }
}

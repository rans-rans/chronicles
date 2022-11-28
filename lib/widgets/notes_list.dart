// ignore_for_file: sort_child_properties_last

import "package:flutter/material.dart";

import '../models/note.dart';
import '../pages/create_note.dart';

class NotesList extends StatelessWidget {
  final List<Note> notes;
  final AnimationController controller;

  const NotesList(this.notes, this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GridView.builder(
        itemCount: notes.length,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 15,
        ),
        itemBuilder: ((context, index) {
          return GestureDetector(
            onTap: () {
              if (controller.isCompleted) {
                controller.reverse();
              }
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreatenotePage(note: notes[index]),
                ),
              );
            },
            child: Card(
              elevation: 8,
              child: GestureDetector(
                child: Center(
                  child: Text(notes[index].title.toString()),
                ),
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

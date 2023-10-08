import "package:flutter/material.dart";

import '../../domain/entities/note_entity.dart';
import '../screens/create_note_page.dart';

class NotesList extends StatelessWidget {
  final List<NoteEntity> notes;
  final AnimationController controller;

  const NotesList(this.notes, this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: notes.length,
      shrinkWrap: true,
      primary: false,
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
                builder: (context) => CreateNotePage(
                  note: notes[index],
                ),
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
    );
  }
}

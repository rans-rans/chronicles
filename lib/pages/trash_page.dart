import 'package:flutter/material.dart';
import 'package:notebook/providers/note_task.dart';

import 'package:provider/provider.dart';

class TrashPage extends StatefulWidget {
  static const routeName = "trash-page";

  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<NoteTask>(context, listen: false).trash;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 210,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text("Trash ✂✂✂"),
              background: Image.asset("assets/images/trash.png"),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                ...notes.map(
                  (note) => Dismissible(
                    key: Key(note.dateCreated.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(color: Colors.red),
                    onDismissed: (direction) {
                      Provider.of<NoteTask>(context, listen: false)
                          .deleteFromTrash(note);
                    },
                    child: ListTile(
                      title: Text(note.title),
                      subtitle: Text(
                        "Date Created: ${note.dateCreated.day}/${note.dateCreated.day}/${note.dateCreated.year}",
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.book),
                        tooltip: "Undo delete",
                        onPressed: () async =>
                            Provider.of<NoteTask>(context, listen: false)
                                .addBackToNotes(note)
                                .then((value) => setState(() {})),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

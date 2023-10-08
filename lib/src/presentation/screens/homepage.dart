import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/note_provider.dart';
import 'create_note_page.dart';
import '../widgets/notes_list.dart';
import '../widgets/search_bar.dart';
import '../widgets/empty_notes.dart';
import '../widgets/custom_floating_action_button.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with SingleTickerProviderStateMixin {
  bool _inSearchMode = false;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    animationController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: CustomFloatingActionButton(animationController),
      body: SafeArea(
        child: Consumer<NoteProvider>(
          builder: (context, noteProvider, child) => FutureBuilder(
            future: noteProvider.getAllNotesFromDatabase(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (noteProvider.allNotes.isEmpty) return const EmptyNotes();
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //heading consisting of the title and search
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 45,
                          horizontal: 10,
                        ),
                        child: switch (_inSearchMode) {
                          true => CustomSearchBar(
                              notes: noteProvider.allNotes,
                              set: () {
                                setState(() => _inSearchMode = false);
                              }),
                          false => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "MY NOTES",
                                  style: TextStyle(
                                    fontSize: 55,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.search),
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () => setState(() {
                                    _inSearchMode = true;
                                  }),
                                ),
                              ],
                            ),
                        },
                      ),
                      const Text("Welcome back,"),
                      InkWell(
                        onTap: () {
                          if (noteProvider.allNotes.isEmpty) return;
                          _inSearchMode = false;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CreateNotePage(
                                note: noteProvider.recent(),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(5, 15, 5, 35),
                          width: double.infinity,
                          height: 150,
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: switch (noteProvider.allNotes.isEmpty) {
                            true => const Text("No Recents here"),
                            false => Text(
                                noteProvider.recent().title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                          },
                        ),
                      ),
                      const Text(
                        "All NOTES",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Flexible(
                        child: NotesList(
                          noteProvider.allNotes,
                          animationController,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

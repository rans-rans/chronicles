// ignore_for_file: curly_braces_in_flow_control_structures, sort_child_properties_last, prefer_final_fields, prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notebook/models/note.dart';
import 'package:notebook/pages/settings_page.dart';
import 'package:notebook/pages/trash_page.dart';
import 'package:notebook/providers/app_settings.dart';
import 'package:notebook/providers/note_task.dart';
import 'package:notebook/pages/create_note.dart';
import 'package:notebook/widgets/greeting_text.dart';
import 'package:notebook/widgets/notes_list.dart';
import 'package:provider/provider.dart';

import '../widgets/fab_button.dart';
import '../widgets/search_bar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  bool inSearchMode = false;
  final scrollController = ScrollController();
  late Stream<List<Note>> listenToNotes;
  late AnimationController animationController;

  double getRadianFromDegree(double degree) {
    double rad = 57.295779513;
    return degree / rad;
  }

  final Stream<String> listenToGreeting = Stream.periodic(
    const Duration(seconds: 1),
    ((computationCount) {
      int time = DateTime.now().hour;

      if (time >= 22 || time < 6)
        return "Beautiful Skies you see";
      else if (time >= 17)
        return "Good evening";
      else if (time >= 12)
        return "Good afternoon";
      else
        return "Good morning";
    }),
  );

  @override
  void initState() {
    super.initState();
    Provider.of<NoteTask>(context, listen: false).getNotesFromStorage();
    listenToNotes = Stream.periodic(const Duration(milliseconds: 1400), (_) {
      final list = Provider.of<NoteTask>(context, listen: false).sortedNotes(
          Provider.of<AppSettings>(context, listen: false).sortingOrder);
      return list;
    });
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
    //don't delete the line below
    Provider.of<AppSettings>(context, listen: false).isAuthenticated = true;

    //you can delete these lines though🤣🤣🤣
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 2),
          content: const Text(
            "DO YOU WANT TO EXIT THE APP ?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          action: SnackBarAction(
            label: "Exit",
            textColor: Colors.deepOrange,
            onPressed: () => SystemNavigator.pop(),
          ),
        ));
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<List<Note>>(
                stream: listenToNotes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const Center(
                          child: CircularProgressIndicator.adaptive()),
                    );
                  final notes = snapshot.data;
                  Note recent =
                      Provider.of<NoteTask>(context, listen: false).recent();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 45,
                          horizontal: 10,
                        ),
                        child: StatefulBuilder(
                          builder: ((context, setState) => inSearchMode
                              ? SearchBar(
                                  notes: notes,
                                  mode: inSearchMode,
                                  set: () => inSearchMode = false,
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      splashColor:
                                          Theme.of(context).primaryColor,
                                      onDoubleTap: () =>
                                          Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CreatenotePage(note: null),
                                        ),
                                      ),
                                      child: Text(
                                        "MY NOTES",
                                        style: TextStyle(
                                          fontSize: 55,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.search),
                                      color: Theme.of(context).primaryColor,
                                      onPressed: () {
                                        inSearchMode = true;
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                )),
                        ),
                      ),
                      GreetingText(listenToGreeting),
                      InkWell(
                        onTap: notes!.isEmpty
                            ? null
                            : () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CreatenotePage(note: recent),
                                  ),
                                ),
                        child: Container(
                          child: notes.isEmpty
                              ? const Text("No Recents here")
                              : Text(
                                  recent.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                          width: double.infinity,
                          height: 150,
                          margin: const EdgeInsets.only(
                            right: 5,
                            left: 5,
                            top: 15,
                            bottom: 35,
                          ),
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                      ),
                      const Text(
                        "All NOTES",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                        ),
                      ),
                      notes.isNotEmpty
                          ? NotesList(
                              notes,
                              animationController,
                            )
                          : const EmptyNotes()
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: StatefulBuilder(builder: (context, setState) {
          return SizedBox(
            height: 135,
            width: 135,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.translate(
                  offset: Offset.fromDirection(
                    getRadianFromDegree(225),
                    animationController.value * 60,
                  ),
                  child: FabButton(
                    color: Colors.green,
                    icon: const Icon(Icons.add, color: Colors.white),
                    opacity: animationController.value,
                    fxn: () {
                      if (animationController.isCompleted)
                        animationController.reverse();
                      Navigator.of(context).pushNamed(CreatenotePage.routeName);
                    },
                  ),
                ),
                Transform.translate(
                  offset: Offset.fromDirection(
                    getRadianFromDegree(315),
                    animationController.value * 60,
                  ),
                  child: FabButton(
                    color: Colors.black,
                    icon: const Icon(Icons.settings, color: Colors.white),
                    opacity: animationController.value,
                    fxn: () {
                      if (animationController.isCompleted)
                        animationController.reverse();

                      Navigator.of(context).pushNamed(SettingsPage.routeName);
                    },
                  ),
                ),
                Transform.translate(
                  offset: Offset.fromDirection(
                    getRadianFromDegree(135),
                    animationController.value * 60,
                  ),
                  child: FabButton(
                      color: Colors.red,
                      icon: const Icon(Icons.delete, color: Colors.white),
                      opacity: animationController.value,
                      fxn: () {
                        if (animationController.isCompleted)
                          animationController.reverse();
                        Navigator.of(context).pushNamed(TrashPage.routeName);
                      }),
                ),
                Transform.translate(
                  offset: Offset.fromDirection(
                    getRadianFromDegree(45),
                    animationController.value * 45,
                  ),
                  child: FabButton(
                    color: Theme.of(context).primaryColor,
                    width: 65,
                    height: 65,
                    icon: const Icon(Icons.menu, color: Colors.white),
                    fxn: () {
                      if (animationController.isCompleted) {
                        animationController.reverse();
                      } else {
                        animationController.forward();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class EmptyNotes extends StatelessWidget {
  const EmptyNotes({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/empty-notes.jpg"),
          const Text(
            "There are no notes",
            style: TextStyle(
              color: Colors.orange,
              fontSize: 23,
            ),
          ),
        ],
      ),
    );
  }
}

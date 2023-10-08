import "package:flutter/material.dart";

import 'search_overlay.dart';
import '../../domain/entities/note_entity.dart';

class CustomSearchBar extends StatefulWidget {
  final List<NoteEntity>? notes;
  final Function set;

  const CustomSearchBar({
    required this.notes,
    required this.set,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<CustomSearchBar> {
  final searchFocus = FocusNode();
  final layerLink = LayerLink();
  final searchController = TextEditingController();
  final _scroll = ScrollController();
  late OverlayEntry entry;
  int resultsFound = 0;
  List<NoteEntity> results = [];

  void showOverlay() {
    final overlay = Overlay.of(context);
    entry.markNeedsBuild();
    overlay.insert(entry);
  }

  void hideOverlay() {
    if (entry.mounted) entry.remove();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox = context.findRenderObject() as RenderBox;
      final size = renderBox.size;

      entry = OverlayEntry(
        builder: ((context) => Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                child: SearchOverlay(scroll: _scroll, results: results, context: context),
                link: layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height - 10),
              ),
            )),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchFocus.dispose();
    searchController.dispose();
    hideOverlay();
    entry.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> searchResults = ValueNotifier(resultsFound);
    return CompositedTransformTarget(
      link: layerLink,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 10, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              autofocus: true,
              controller: searchController,
              focusNode: searchFocus,
              cursorColor: Theme.of(context).primaryColor,
              cursorHeight: 15,
              autocorrect: false,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 23,
              ),
              //the onChanged handler
              onChanged: (text) {
                final notes = widget.notes;
                if (notes!.isEmpty) {
                  resultsFound = 0;
                  return;
                }
                if (text.isEmpty) {
                  resultsFound = 0;
                  hideOverlay();
                  return;
                }
                final sugguestions = notes.where((element) {
                  final title = element.title.toLowerCase();
                  final input = text.toLowerCase();
                  return title.contains(input);
                }).toList();
                results = sugguestions;
                if (results.isEmpty) {
                  resultsFound = 0;
                  return;
                }
                resultsFound = results.length;
                if (entry.mounted) {
                  setState(() {});
                } else {
                  showOverlay();
                }
              },
              // the onSubmitted handler
              onSubmitted: (value) {
                hideOverlay();
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(3),

                // icon in the searchField function
                suffixIcon: IconButton(
                  icon: const Icon(Icons.cancel),
                  color: Colors.black,
                  onPressed: () {
                    searchController.clear();
                    searchFocus.unfocus();
                    widget.set();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: searchResults,
              builder: (_, value, __) => Text("$value results found"),
            ),
          ],
        ),
      ),
    );
  }
}

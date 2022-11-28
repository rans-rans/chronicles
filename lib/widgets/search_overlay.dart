import 'package:flutter/material.dart';

import '../models/note.dart';
import '../pages/create_note.dart';

class SearchOverlay extends StatelessWidget {
  const SearchOverlay({
    Key? key,
    required ScrollController scroll,
    required this.results,
    required this.context,
  })  : _scroll = scroll,
        super(key: key);

  final ScrollController _scroll;
  final List<Note> results;
  final BuildContext context;

  @override
  Widget build(BuildContext context) => Material(
        elevation: 8,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: SizedBox(
          height: 150,
          child: Scrollbar(
            controller: _scroll,
            thumbVisibility: true,
            radius: const Radius.circular(5),
            thickness: 6,
            child: SingleChildScrollView(
              controller: _scroll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...results.map(
                    (result) => ListTile(
                      isThreeLine: false,
                      title: Text(result.title),
                      contentPadding: const EdgeInsets.all(3),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CreatenotePage(note: result),
                          ),
                        );
                      },
                      subtitle: Text(
                        result.contents,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

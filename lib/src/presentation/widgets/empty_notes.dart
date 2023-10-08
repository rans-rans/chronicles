import 'package:flutter/material.dart';

class EmptyNotes extends StatelessWidget {
  const EmptyNotes({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/empty-notes.jpg"),
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

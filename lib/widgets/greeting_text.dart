// ignore_for_file: curly_braces_in_flow_control_structures

import "package:flutter/material.dart";

class GreetingText extends StatelessWidget {
  final Stream listenToGreeting;
  const GreetingText(this.listenToGreeting, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: listenToGreeting,
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Text("Greetings, ");
        return Text(
            "${snapshot.data.toString().toUpperCase()}, get back to your recent work");
      }),
    );
  }
}

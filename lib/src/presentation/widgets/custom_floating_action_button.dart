import 'package:flutter/material.dart';

import '../screens/create_note_page.dart';
import 'fab_button.dart';

class CustomFloatingActionButton extends StatefulWidget {
  final AnimationController animationController;
  const CustomFloatingActionButton(this.animationController, {super.key});

  @override
  State<CustomFloatingActionButton> createState() => _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState extends State<CustomFloatingActionButton> {
  double getRadianFromDegree(double degree) {
    double rad = 57.295779513;
    return degree / rad;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 135,
      width: 135,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: Offset.fromDirection(
              getRadianFromDegree(225),
              widget.animationController.value * 60,
            ),
            child: FabButton(
              color: Colors.green,
              icon: const Icon(Icons.add, color: Colors.white),
              opacity: widget.animationController.value,
              fxn: () {
                if (widget.animationController.isCompleted) {
                  widget.animationController.reverse();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const CreateNotePage(note: null);
                      },
                    ),
                  );
                }
              },
            ),
          ),
          // TODO add settings and trash page later
          // Transform.translate(
          //   offset: Offset.fromDirection(
          //     getRadianFromDegree(315),
          //     widget.animationController.value * 60,
          //   ),
          //   child: FabButton(
          //     color: Colors.black,
          //     icon: const Icon(Icons.settings, color: Colors.white),
          //     opacity: widget.animationController.value,
          //     fxn: () {
          //       _inSearchMode = false;
          //       if (animationController.isCompleted) animationController.reverse();
          //       Navigator.of(context).pushNamed("/settings-page");
          //     },
          //   ),
          // ),
          // Transform.translate(
          //   offset: Offset.fromDirection(
          //     getRadianFromDegree(135),
          //     widget.animationController.value * 60,
          //   ),
          //   child: FabButton(
          //       color: Colors.red,
          //       icon: const Icon(Icons.delete, color: Colors.white),
          //       opacity: widget.animationController.value,
          //       fxn: () {
          //         _inSearchMode = false;
          //         if (animationController.isCompleted) animationController.reverse();
          //         Navigator.of(context).pushNamed("/trash-page");
          //       }),
          // ),
          Transform.translate(
            offset: Offset.fromDirection(
              getRadianFromDegree(45),
              widget.animationController.value * 45,
            ),
            child: FabButton(
              color: Theme.of(context).primaryColor,
              width: 65,
              height: 65,
              icon: const Icon(Icons.menu, color: Colors.white),
              fxn: () {
                if (widget.animationController.isCompleted) {
                  widget.animationController.reverse();
                } else {
                  widget.animationController.forward();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

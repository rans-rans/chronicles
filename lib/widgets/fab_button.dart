// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

class FabButton extends StatelessWidget {
  final double width;
  final double height;
  final double opacity;
  final Color color;
  final Icon icon;
  final Function() fxn;

  const FabButton({
    super.key,
    this.width = 45,
    this.height = 45,
    this.opacity = 1,
    required this.color,
    required this.icon,
    required this.fxn,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fxn,
      child: Opacity(
        opacity: opacity,
        child: Container(
          child: icon,
          height: height,
          width: width,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_settings.dart';

class FontDialog extends StatelessWidget {
  MyFont myFont;
  FontDialog(this.myFont, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          child: const Text("OK"),
          onPressed: () async => await Provider.of<AppSettings>(
            context,
            listen: false,
          ).toggleFont(myFont).then(
                (_) => Navigator.of(context).pop(),
              ),
        ),
      ],
      content: StatefulBuilder(builder: (context, setState) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Radio(
                    value: MyFont.DancingScript,
                    groupValue: myFont,
                    onChanged: (value) => setState(() => myFont = value!),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Dancing",
                    style: TextStyle(fontFamily: "DancingScript"),
                  )
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: MyFont.IndieFlower,
                    groupValue: myFont,
                    onChanged: (value) => setState(() => myFont = value!),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Indie",
                    style: TextStyle(fontFamily: "IndieFlower"),
                  )
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: MyFont.RobotoMono,
                    groupValue: myFont,
                    onChanged: (value) => setState(() => myFont = value!),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Roboto Mono",
                    style: TextStyle(fontFamily: "RobotoMono"),
                  )
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

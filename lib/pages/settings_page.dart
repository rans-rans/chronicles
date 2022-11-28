import "package:flutter/material.dart";
import 'package:notebook/pages/security_page.dart';
import 'package:notebook/providers/app_settings.dart';
import 'package:notebook/widgets/font_dialog.dart';

import 'package:notebook/widgets/sorting_dialog.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = "/settings-page";
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    SortingOrder sortingOrder =
        Provider.of<AppSettings>(context, listen: false).sortingOrder;
    MyFont font = MyFont.values.firstWhere(
      (element) =>
          element == Provider.of<AppSettings>(context, listen: false).myFont,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            //theme
            StatefulBuilder(
              builder: (context, setState) {
                return SwitchListTile.adaptive(
                    title: const Text("Dark Theme"),
                    subtitle: const Text("Change the app theme"),
                    value: Provider.of<AppSettings>(context, listen: false)
                        .isDarkTheme(),
                    onChanged: (_) async {
                      await Provider.of<AppSettings>(
                        context,
                        listen: false,
                      ).toggleTheme();
                      return setState(() {});
                    });
              },
            ),
            //sorting order
            ListTile(
              title: const Text("Sorting order"),
              subtitle: const Text("Set the sorting order of your notes"),
              onTap: () => showDialog(
                context: context,
                builder: ((context) => SortingDialog(sortingOrder)),
              ).then((value) => setState(() {})),
            ),

            //security and password
            ListTile(
              title: const Text("Security"),
              subtitle: const Text("Enable, change or disable password"),
              onTap: () => Navigator.of(context).pushNamed(
                SecurityPage.routeName,
              ),
            ),

            //changing the fontStyle
            ListTile(
              title: const Text("Note Font"),
              subtitle: const Text("Change the font style for your notes"),
              onTap: () => showDialog(
                      context: context, builder: (context) => FontDialog(font))
                  .then((value) => setState(() {})),
            ),
            ListTile(
              title: const Text("Developer contact"),
              onTap: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  elevation: 25,
                  title: const Text("About Us"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      ListTile(
                        title: Text("Developer"),
                        subtitle: Text("Rans innovations"),
                        contentPadding: EdgeInsets.all(3),
                      ),
                      ListTile(
                        title: Text("Contact us"),
                        subtitle: Text("Email: ransfordowusuansah9@gmail.com"),
                        contentPadding: EdgeInsets.all(3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //privacy info
            // ListTile(
            //   title: const Text(
            //     "Privacy policy",
            //     style: TextStyle(fontWeight: FontWeight.bold),
            //   ),
            //   onTap: () {},
            // ),
          ]),
        ),
      ),
    );
  }
}

enum SortingOrder {
  titleAscending,
  titleDescending,
  dateCreatedAscending,
  dateCreatedDescending,
  dateModifiedAscending,
  dateModifiedDescending,
}

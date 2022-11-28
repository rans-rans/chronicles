// ignore_for_file: sort_child_properties_last

import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import './pages/authentication_page.dart';
import '/pages/security_page.dart';
import '/pages/settings_page.dart';
import '/pages/trash_page.dart';

import '/providers/note_task.dart';
import '/pages/create_note.dart';
import '/providers/app_settings.dart';

import 'pages/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.loadSettings();
  runApp(
    MultiProvider(
      child: const MyApp(),
      providers: [
        ChangeNotifierProvider(create: (context) => NoteTask()),
        ChangeNotifierProvider(create: (context) => AppSettings()),
      ],
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
          Provider.of<AppSettings>(context, listen: false).isPasswordEnabled &&
                  Provider.of<AppSettings>(context, listen: false)
                      .password
                      .isNotEmpty &&
                  Provider.of<AppSettings>(context, listen: false)
                          .isAuthenticated ==
                      false
              ? const AuthenticationPage()
              : const Homepage(),
      title: "My Chronicles",
      debugShowCheckedModeBanner: false,
      theme: Provider.of<AppSettings>(context).lightTheme,
      darkTheme: Provider.of<AppSettings>(context).darkTheme,
      themeMode: Provider.of<AppSettings>(context).themeMode,
      routes: {
        CreatenotePage.routeName: (context) => const CreatenotePage(note: null),
        SettingsPage.routeName: (context) => const SettingsPage(),
        TrashPage.routeName: (context) => const TrashPage(),
        SecurityPage.routeName: (context) => const SecurityPage(),
        AuthenticationPage.routeName: (context) => const AuthenticationPage(),
      },
    );
  }
}

import '/src/injector.dart';
import 'package:flutter/material.dart';

import 'src/data/sql_database_helper.dart';
import 'src/presentation/screens/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await DatabaseHelper.instance.database;
  runApp(
    Injector(const MyApp(), database),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Homepage(),
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(useMaterial3: true),
    );
  }
}

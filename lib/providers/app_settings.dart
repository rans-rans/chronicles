// ignore_for_file: prefer_final_fields, curly_braces_in_flow_control_structures, constant_identifier_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:notebook/pages/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings with ChangeNotifier {
  static SharedPreferences? _shared;
  static ThemeMode _thememode = ThemeMode.light;
  static SortingOrder _noteSortingOrder = SortingOrder.dateCreatedAscending;
  static bool _isPasswordEnabled = false;
  static String _password = "";
  static MyFont _myFont = MyFont.RobotoMono;
  bool isAuthenticated = false;

  String get password => _password;

  Future<void> changePassword(String change) async {
    _password = change;
    _isPasswordEnabled = true;
    notifyListeners();
    await _shared!.setString("password", _password);
    await _shared!.setBool("isPasswordEnabled", _isPasswordEnabled);
  }

  ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color.fromARGB(255, 133, 86, 69),
    accentColor: const Color.fromARGB(115, 133, 86, 69),
    appBarTheme: const AppBarTheme(
      color: Color.fromARGB(255, 133, 86, 69),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Colors.yellow),
      trackColor: MaterialStateProperty.all(Colors.brown),
    ),
  );

  ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color.fromARGB(255, 112, 144, 192),
    accentColor: const Color.fromARGB(115, 112, 144, 192),
    appBarTheme: const AppBarTheme(
      color: Color.fromARGB(255, 12, 35, 70),
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      textStyle: MaterialStateProperty.all(
        const TextStyle(color: Colors.white),
      ),
    )),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Colors.yellow),
      trackColor:
          MaterialStateProperty.all(const Color.fromARGB(255, 12, 35, 70)),
    ),
  );

  SharedPreferences? get preferences => _shared;
  ThemeMode get themeMode => _thememode;
  SortingOrder get sortingOrder => _noteSortingOrder;
  MyFont get myFont => _myFont;
  bool get isPasswordEnabled => _isPasswordEnabled;

  bool isDarkTheme() {
    if (_thememode == ThemeMode.dark) return true;
    return false;
  }

  static Future<bool> isPasswordSet() async {
    final value = _shared!.getBool("isPasswordEnabled");
    if (value == null) return false;
    return value;
  }

  static Future<String> loadPassword() async {
    final pass = _shared!.getString("password");
    if (pass == null) return "";
    return pass;
  }

  static Future<ThemeMode> loadTheme() async {
    bool? isLight = _shared!.getBool("theme-mode");
    if (isLight == null)
      return ThemeMode.light;
    else {
      if (isLight) return ThemeMode.light;
      return ThemeMode.dark;
    }
  }

  static Future<SortingOrder> loadSortingOrder() async {
    final order = _shared!.getString("sorting-order");
    if (order == null) return SortingOrder.dateCreatedAscending;
    return SortingOrder.values
        .firstWhere((element) => element.toString() == order);
  }

  static Future<MyFont> loadFont() async {
    final font = _shared!.getString("font");
    if (font == null) return MyFont.RobotoMono;
    return MyFont.values.firstWhere((element) => element.toString() == font);
  }

  Future<void> toggleFont(MyFont font) async {
    _myFont = font;
    await _shared!.setString("font", _myFont.toString());
    notifyListeners();
  }

  Future<void> togglePassword() async {
    _isPasswordEnabled = !_isPasswordEnabled;
    await _shared!.setBool("isPasswordEnabled", _isPasswordEnabled);
  }

  Future<void> toggleSortingOrder(SortingOrder order) async {
    _noteSortingOrder = order;
    final shared = await SharedPreferences.getInstance();
    await shared.setString("sorting-order", order.toString());
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    if (_thememode == ThemeMode.light)
      _thememode = ThemeMode.dark;
    else
      _thememode = ThemeMode.light;
    notifyListeners();
    final shared = await SharedPreferences.getInstance();
    final isLight = _thememode == ThemeMode.light ? true : false;
    await shared.setBool("theme-mode", isLight);
  }

  static Future loadSettings() async {
    _shared = await SharedPreferences.getInstance();
    _thememode = await loadTheme();
    _password = await loadPassword();
    _isPasswordEnabled = await isPasswordSet();
    _noteSortingOrder = await loadSortingOrder();
    loadFont().then((value) => _myFont = value);
  }
}

enum MyFont {
  DancingScript,
  IndieFlower,
  RobotoMono,
}

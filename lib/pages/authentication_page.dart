// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:notebook/pages/homepage.dart';
import 'package:notebook/providers/app_settings.dart';
import 'package:provider/provider.dart';

class AuthenticationPage extends StatefulWidget {
  static const routeName = "auth";
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _password.dispose();
  }

  String? validatePassword(String text) {
    if (text.isEmpty) return "Field cannot be empty";
    if (text != Provider.of<AppSettings>(context, listen: false).password) {
      return "Wrong password";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final fxn = Provider.of<AppSettings>(context, listen: false);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Colors.brown,
                Colors.brown.shade300,
                Colors.brown.shade800,
                Colors.brown.shade600,
                const Color.fromARGB(255, 112, 144, 192),
              ],
            )),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: TextField(
                  controller: _password,
                  textInputAction: TextInputAction.go,
                  style: const TextStyle(fontSize: 30, color: Colors.white),
                  autofocus: false,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  textAlign: TextAlign.end,
                  onEditingComplete: () {
                    final value = validatePassword(_password.text);
                    if (value == null) {
                      showToast(
                        "Authenticated",
                        context: context,
                        animation: StyledToastAnimation.scale,
                        dismissOtherToast: true,
                      );
                      fxn.isAuthenticated = true;
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: ((context) => const Homepage()),
                        ),
                      );
                    } else {
                      FocusScope.of(context).unfocus();
                      _password.clear();
                      showToast(
                        "Wrong password",
                        context: context,
                        animation: StyledToastAnimation.scale,
                        dismissOtherToast: true,
                      );
                    }
                  },
                  cursorColor: fxn.themeMode == ThemeMode.light
                      ? Colors.brown
                      : Colors.white,
                  decoration: InputDecoration(
                    labelText: "Enter password",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: fxn.themeMode == ThemeMode.light
                            ? Colors.brown
                            : const Color.fromARGB(255, 12, 35, 70),
                      ),
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

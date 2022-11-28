// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:notebook/providers/app_settings.dart';
import 'package:provider/provider.dart';

class SecurityPage extends StatefulWidget {
  static const routeName = "security-page";
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _confirmFocus = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _confirmFocus.dispose();
  }

  String? validatePassword(String value, String other) {
    if (value.isEmpty) return "field cannot be empty";
    if (value.length < 5) return "field must have more than four digits";
    if (value != other) return "password do not match";
    return null;
  }

  Future<void> changePassword() async {
    final one = validatePassword(
      _passwordController.text,
      _confirmController.text,
    );
    final two = validatePassword(
      _passwordController.text,
      _confirmController.text,
    );
    if (one != null || two != null) {
      FocusScope.of(context).unfocus();
      return;
    }

    await Provider.of<AppSettings>(context, listen: false)
        .changePassword(_passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final fxn = Provider.of<AppSettings>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text("Security")),
      body: Column(
        children: [
          SwitchListTile.adaptive(
            title: const Text("Enable password"),
            contentPadding: const EdgeInsets.all(10),
            value: fxn.isPasswordEnabled,
            onChanged: (_) async =>
                await fxn.togglePassword().then((value) => setState(() {})),
          ),
          ListTile(
            enabled: fxn.isPasswordEnabled,
            contentPadding: const EdgeInsets.all(10),
            title: const Text("Change Password"),
            onTap: () =>
                showPasswordDialog(context).then((_) => setState(() {})),
          )
        ],
      ),
    );
  }

  Future<dynamic> showPasswordDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            actions: [
              TextButton(
                child: const Text("CHANGE"),
                onPressed: () async => await changePassword().then(
                  (value) => Navigator.of(context).pop(),
                ),
              ),
              TextButton(
                child: const Text("CANCEL"),
                onPressed: () => Navigator.of(context).pop(false),
              )
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _passwordController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  maxLength: 10,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_confirmFocus),
                  decoration: InputDecoration(
                    labelText: "Password",
                    errorText: validatePassword(
                      _passwordController.text,
                      _confirmController.text,
                    ),
                  ),
                ),
                TextField(
                  obscureText: true,
                  controller: _confirmController,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  focusNode: _confirmFocus,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    errorText: validatePassword(
                      _passwordController.text,
                      _confirmController.text,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

import 'package:flutter/services.dart' show MethodChannel;

Future<dynamic> showToast({
  required String message,
  required MethodChannel channel,
}) async {
  channel.invokeMethod("show_toast", message);
}

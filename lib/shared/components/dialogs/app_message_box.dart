import 'package:flutter/material.dart';

enum AppMessageType { success, error, info, warning }

class AppMessageBox {
  static void show(
      BuildContext context, {
        required String message,
        AppMessageType type = AppMessageType.info,
      }) {
    Color background;

    switch (type) {
      case AppMessageType.success:
        background = const Color(0xFF166534);
        break;
      case AppMessageType.error:
        background = const Color(0xFF991B1B);
        break;
      case AppMessageType.warning:
        background = const Color(0xFF92400E);
        break;
      case AppMessageType.info:
        background = const Color(0xFF1D4ED8);
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: background,
        content: Text(message),
      ),
    );
  }
}

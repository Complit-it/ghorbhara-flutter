import 'package:flutter/material.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg,
      {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor:
            backgroundColor, // If null, defaults to the standard color
      ),
    );
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => Center(child: CircularProgressIndicator()));
  }

  static void showProgressBarWithText(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(color: const Color.fromARGB(255, 65, 63, 63)),
            ),
          ],
        ),
      ),
    );
  }
}

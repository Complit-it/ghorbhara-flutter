import 'package:flutter/material.dart';

void showErrorSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(Icons.error, color: Colors.white),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Hind',
            ),
          ),
        ),
      ],
    ),
    backgroundColor: Colors.redAccent,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    duration: Duration(seconds: 3),
    // action: SnackBarAction(
    //   label: 'Retry',
    //   textColor: Colors.white,
    //   onPressed: () {
    //     // Add your retry logic here
    //   },
    // ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

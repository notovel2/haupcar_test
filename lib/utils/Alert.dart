import 'package:flutter/material.dart';

class ErrorHandler {
  static showAlertDialog(
    BuildContext context,
    String title) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
        AlertDialog(
          title: Text(title),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        )
    );
  }
}
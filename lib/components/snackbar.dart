import 'package:flutter/material.dart';

void snackbar(BuildContext context, String alertContent, int time) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.blueGrey,
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          alertContent,
          textAlign: TextAlign.center,
        ),
      ),
      duration: Duration(seconds: time),
    ),
  );
}

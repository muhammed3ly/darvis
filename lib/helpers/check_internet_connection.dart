import 'dart:io';

import 'package:flutter/material.dart';

Future<bool> checkConnection(BuildContext context) async {
  try {
    await InternetAddress.lookup('google.com');
    return true;
  } on SocketException catch (_) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color.fromRGBO(3, 155, 229, 1),
        content: Text(
          'Please check your internet connection and try again.',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "ok",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
    return false;
  }
}

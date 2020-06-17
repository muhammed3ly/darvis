import 'package:flutter/material.dart';

class introScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FittedBox(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 10),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          CircularProgressIndicator(),
          Text('Loading..'),
        ],
      ),
    );
  }
}

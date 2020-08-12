import 'package:flutter/material.dart';

class TempSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromRGBO(244, 240, 247, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            Text(
              'Loading...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

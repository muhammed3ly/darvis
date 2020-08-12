import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 240, 247, 1),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Image.asset('assets/images/logo.jpg'),
        ),
      ),
    );
  }
}

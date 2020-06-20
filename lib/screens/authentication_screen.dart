import 'package:chat_bot/screens/sign_in_screen.dart';
import 'package:chat_bot/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';

enum AuthMode { SignIn, SignUp }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode authMode;
  @override
  void initState() {
    super.initState();
    authMode = AuthMode.SignIn;
  }

  void toggleAuthMode() {
    setState(() {
      if (authMode == AuthMode.SignIn) {
        authMode = AuthMode.SignUp;
      } else {
        authMode = AuthMode.SignIn;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: authMode == AuthMode.SignIn
          ? SignInScreen(toggleAuthMode)
          : SignUpScreen(toggleAuthMode),
    );
  }
}

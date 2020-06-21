import 'package:chat_bot/screens/temp_splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/categories.dart';
import './providers/users.dart';
import './screens/authentication_screen.dart';
import './screens/home_screen.dart';
import './helpers/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Categories()),
        ChangeNotifierProvider(create: (_) => User())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Darvis',
        theme: ThemeData(
          primarySwatch: Constants.customColor,
          accentColor: Colors.white,
        ),
        home: Consumer<User>(
          builder: (_, user, __) => StreamBuilder(
              stream: FirebaseAuth.instance.onAuthStateChanged,
              builder: (ctx, userSnapShort) {
                if (userSnapShort.hasData == false) {
                  return AuthScreen();
                }
                return user.isSigning ? TempSplashScreen() : HomeScreen();
              }),
        ),
      ),
    );
  }
}

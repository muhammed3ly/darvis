import 'package:chat_bot/providers/categories.dart';
import 'package:chat_bot/screens/authentication_screen.dart';
import 'package:chat_bot/screens/home_screen.dart';
import 'package:chat_bot/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/users.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        title: 'Darvis',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (ctx, userSnapShort) {
            print('here for stream'); 
            print(userSnapShort.hasData);
            if (userSnapShort.hasData) {
              return HomeScreen(signUp: true);
            }
            return AuthScreen();
          },
        ),
//        home: AuthScreen(),
        routes: {
          AuthScreen.routeName: (_) => AuthScreen(),
          HomeScreen.routeName: (_) => HomeScreen(),
          SignUpScreen.routeName: (_) => SignUpScreen(),
        },
      ),
    );
  }
}

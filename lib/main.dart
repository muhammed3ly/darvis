import 'package:darvis/screens/chat_screen.dart';
import 'package:darvis/screens/home_screen.dart';
import 'package:darvis/screens/settings_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DARVIS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      /* routes: {
        ChatScreen.routeName: (context) => ChatScreen(),
        SettingsScreen.routeName: (context) => SettingsScreen(),
      },*/
    );
  }
}

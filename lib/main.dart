import 'package:chat_bot/screens/chat_screen.dart';
import 'package:chat_bot/screens/my_favorites.dart';
import 'package:chat_bot/screens/profile_screen.dart';
import 'package:chat_bot/screens/temp_splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import './helpers/constants.dart';
import './providers/categories.dart';
import './providers/users.dart';
import './screens/authentication_screen.dart';

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
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Darvis',
        theme: ThemeData(
          primarySwatch: Constants.customColor,
          accentColor: Colors.white,
          fontFamily: 'Poppins',
        ),
        home: Consumer<User>(
          builder: (_, user, __) => StreamBuilder(
              stream: FirebaseAuth.instance.onAuthStateChanged,
              builder: (ctx, userSnapShort) {
                if (userSnapShort.hasData == false) {
                  return AuthScreen();
                }
                return user.isSigning
                    ? TempSplashScreen()
                    : MyFavoritesScreen();
              }),
        ),
        routes: {
          ProfileScreen.routeName: (context) => ProfileScreen(),
          MyFavoritesScreen.routeName: (context) => MyFavoritesScreen(),
          ChatScreen.routeName: (context) => ChatScreen(),
        },
      ),
    );
  }
}

import 'package:chat_bot/screens/chat_screen.dart';
import 'package:chat_bot/screens/my_favorites.dart';
import 'package:chat_bot/screens/profile_screen.dart';
import 'package:chat_bot/screens/sign_in_screen.dart';
import 'package:chat_bot/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import './helpers/constants.dart';
import './providers/categories.dart';
import './providers/users.dart';
import 'helpers/custom_route.dart';
import 'screens/sign_up_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Categories()),
        ChangeNotifierProvider(create: (_) => User()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Darvis',
        theme: ThemeData(
          primarySwatch: Constants.lightPrimaryColor,
          accentColor: Colors.white,
          fontFamily: 'Poppins',
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            },
          ),
        ),
        home: Builder(
          builder: (context) {
            return FutureBuilder(
                future: FirebaseAuth.instance.currentUser(),
                builder: (ctx, userSnapShort) {
                  if (userSnapShort.hasData == false) {
                    return SignInScreen();
                  }
                  return FutureBuilder(
                      future:
                          Provider.of<User>(context, listen: false).loadData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SplashScreen();
                        }
                        Provider.of<Categories>(context, listen: false)
                            .setCategories(snapshot.data);
                        return ChatScreen();
                      });
                });
          },
        ),
        routes: {
          SignInScreen.routeName: (context) => SignInScreen(),
          SignUpScreen.routeName: (context) => SignUpScreen(),
          ProfileScreen.routeName: (context) => ProfileScreen(),
          MyFavoritesScreen.routeName: (context) => MyFavoritesScreen(),
          ChatScreen.routeName: (context) => ChatScreen(),
        },
      ),
    );
  }
}

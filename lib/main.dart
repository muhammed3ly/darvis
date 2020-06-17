import './screens/home_screen.dart';
import './providers/categories.dart';
import './screens/authentication_screen.dart';
import './screens/sign_up_screen.dart';
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
        debugShowCheckedModeBanner: false,
        title: 'Darvis',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color.fromRGBO(3, 155, 229, 1),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (ctx, userSnapShort) {
            print('here for stream');
            print(userSnapShort.hasData);
//            if (userSnapShort.connectionState == ConnectionState.waiting) {
//              return Scaffold(
//                body: Center(
//                  child: CircularProgressIndicator(),
//                ),
//              );
//            }
            if (userSnapShort.hasData) {
              return HomeScreen();
            }
            return AuthScreen();
          },
        ),
//        home: HomeScreen(),

        routes: {
          AuthScreen.routeName: (_) => AuthScreen(),
          HomeScreen.routeName: (_) => HomeScreen(),
          SignUpScreen.routeName: (_) => SignUpScreen(),
        },
      ),
    );
  }
}

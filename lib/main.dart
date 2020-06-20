import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/categories.dart';
import './providers/users.dart';
import './screens/authentication_screen.dart';
import './screens/home_screen.dart';
import './screens/sign_up_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.signOut();

    super.initState();
  }

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
            print(userSnapShort.hasData);
            print('here for the stream');
            if (userSnapShort.hasData == false) return AuthScreen();
            if (Provider.of<User>(ctx, listen: false).isSigning) {
              return FutureBuilder(
                future: Provider.of<User>(ctx, listen: false).signUp(),
                builder: (ctx2, snapShot) {
                  if (snapShot.hasData) {
                    return HomeScreen();
                  } else {
                    return Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              );
            } else {
              return FutureBuilder(
                future: Provider.of<User>(ctx, listen: false).loadData(),
                builder: (ctx2, snapShot) {
                  if (snapShot.hasData) {
                    print(snapShot.data);
                    Provider.of<Categories>(ctx2, listen: false)
                        .set(snapShot.data);
                    return HomeScreen();
                  } else {
                    return Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              );
            }
          },
        ),
        routes: {
          AuthScreen.routeName: (_) => AuthScreen(),
          HomeScreen.routeName: (_) => HomeScreen(),
          SignUpScreen.routeName: (_) => SignUpScreen(),
        },
      ),
    );
  }
}

import 'package:chat_bot/providers/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';

class HiddenDrawer extends StatefulWidget {
  @override
  _HiddenDrawerState createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  final width = 150.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(3, 155, 229, 1),
              Colors.black,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, 1],
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  elevation: 8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: Container(
                      height: 150,
                      width: 120,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(3, 155, 229, 1),
                            Colors.black,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0, 1],
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          alignment: Alignment.center,
                          children: <Widget>[
                            Image.network(
                              Provider.of<User>(context).imageUrl,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                color: Colors.black38,
                                width: 110,
                                height: 20,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Center(
                                  child: Text(
                                    Provider.of<User>(context).userName,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    SimpleHiddenDrawerProvider.of(context)
                        .setSelectedMenuPosition(0);
                  },
                  child: Container(
                      width: width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(3, 155, 229, 1),
                            Colors.black,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0, 1],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "My Favorites",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      )),
                ),
                Container(
                  width: width,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.only(
                    //   topLeft: Radius.circular(25),
                    //   bottomRight: Radius.circular(25),
                    // ),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(3, 155, 229, 1),
                        Colors.black,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0, 1],
                    ),
                  ),
                  child: FlatButton(
                    textColor: Colors.white,
                    onPressed: () {
                      SimpleHiddenDrawerProvider.of(context)
                          .setSelectedMenuPosition(1);
                    },
                    child: Text("Chat Screen"),
                  ),
                ),
                Container(
                  width: width,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.only(
                    //   topLeft: Radius.circular(25),
                    //   bottomRight: Radius.circular(25),
                    // ),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(3, 155, 229, 1),
                        Colors.black,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0, 1],
                    ),
                  ),
                  child: FlatButton(
                    textColor: Colors.white,
                    onPressed: () {
                      SimpleHiddenDrawerProvider.of(context)
                          .setSelectedMenuPosition(2);
                    },
                    child: Text("Settings Screen"),
                  ),
                ),
                Container(
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      // topLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(3, 155, 229, 1),
                        Colors.black,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0, 1],
                    ),
                  ),
                  child: FlatButton(
                    textColor: Colors.white,
                    onPressed: () async {
                      Provider.of<Categories>(context, listen: false).clear();
                      await FirebaseAuth.instance.signOut();
                    },
                    child: Text("Sign Out"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

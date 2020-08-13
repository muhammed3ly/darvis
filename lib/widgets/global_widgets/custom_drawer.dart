import 'package:chat_bot/screens/sign_in_screen.dart';
import 'package:chat_bot/widgets/global_widgets/drawer_sections.dart/custom_drawer_header.dart';
import 'package:chat_bot/widgets/global_widgets/drawer_sections.dart/navigation_section.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'drawer_sections.dart/app_section.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Drawer(
        elevation: 10,
        child: Container(
          color: Colors.white,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              CustomDrawerHeader(),
              NavigationSection(),
              AppSection(),
              Container(
                height: 50,
                margin: const EdgeInsets.only(
                  top: 20,
                  bottom: 10,
                ).add(
                  const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                ),
                child: FlatButton(
                  shape: StadiumBorder(),
                  color: Color.fromRGBO(53, 77, 175, 1),
                  child: Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushReplacementNamed(SignInScreen.routeName);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

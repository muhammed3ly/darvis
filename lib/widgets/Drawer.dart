import 'package:chat_bot/providers/categories.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(title: Text('setting')),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign out'),
            onTap: () async {
              Provider.of<Categories>(context, listen: false).clear();
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}

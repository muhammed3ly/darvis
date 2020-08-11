import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_bot/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatNavigationSectionItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 22, bottom: 15),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacementNamed(ChatScreen.routeName);
        },
        child: Row(
          children: <Widget>[
            AvatarGlow(
              glowColor: Color.fromRGBO(255, 148, 148, 1),
              endRadius: 33.0,
              duration: Duration(seconds: 2),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: Duration(milliseconds: 50),
              child: Icon(
                Icons.message,
                color: Color.fromRGBO(53, 77, 175, 1),
                size: 30 * MediaQuery.of(context).textScaleFactor,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Let\'s Chat',
              style: TextStyle(
                color: Color.fromRGBO(53, 77, 175, 1),
                fontSize: 20 * MediaQuery.of(context).textScaleFactor,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

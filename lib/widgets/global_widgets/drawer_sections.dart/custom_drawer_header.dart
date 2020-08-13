import 'package:flutter/material.dart';

class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.only(bottom: 15, left: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(221, 220, 240, 1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Image.asset(
            'assets/images/Asset 01.png',
            scale: 3,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'DARVIS',
                style: TextStyle(
                  letterSpacing: 2,
                  color: Color.fromRGBO(53, 77, 176, 1),
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              Text(
                'CHATBOT',
                style: TextStyle(
                  letterSpacing: 6,
                  color: Color.fromRGBO(81, 81, 81, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color.fromRGBO(53, 77, 176, 1),
              size: 26,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

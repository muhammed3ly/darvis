import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  final List<Widget> children;
  final title;
  SettingsSection({@required this.title, @required this.children});
  @override
  Widget build(BuildContext context) {
    List<Widget> items = <Widget>[
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 6),
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(3, 155, 229, 1),
                  fontSize: 30,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          )
        ] +
        children;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: items,
          ),
        ),
      ),
    );
  }
}

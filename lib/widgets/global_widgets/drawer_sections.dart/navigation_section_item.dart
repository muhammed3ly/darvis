import 'package:flutter/material.dart';

class NavigationSectionItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;
  NavigationSectionItem({
    @required this.icon,
    @required this.title,
    @required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(bottom: title == 'Profile' ? 30 : 15, left: 40),
      child: InkWell(
        onTap: this.onTap,
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                this.icon,
                color: Color.fromRGBO(53, 77, 175, 1),
                size: (title == 'Profile' ? 35 : 30),
              ),
              SizedBox(
                width: 30,
              ),
              Text(
                this.title,
                style: TextStyle(
                  color: Color.fromRGBO(53, 77, 175, 1),
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

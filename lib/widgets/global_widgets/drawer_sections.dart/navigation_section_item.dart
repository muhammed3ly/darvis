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
      margin: EdgeInsets.only(bottom: title == 'Profile' ? 30 : 15, left: 40),
      child: InkWell(
        onTap: this.onTap,
        child: Row(
          children: <Widget>[
            Icon(
              this.icon,
              color: Color.fromRGBO(53, 77, 175, 1),
              size: (title == 'Profile' ? 35 : 30) *
                  MediaQuery.of(context).textScaleFactor,
            ),
            SizedBox(
              width: 30,
            ),
            Text(
              this.title,
              style: TextStyle(
                color: Color.fromRGBO(53, 77, 175, 1),
                fontSize: 20 * MediaQuery.of(context).textScaleFactor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double _preferredHeight = 80.0;

  final String title;
  final Color gradientBegin, gradientEnd;
  final Function toggle;
  GradientAppBar({
    @required this.title,
    @required this.gradientBegin,
    @required this.gradientEnd,
    @required this.toggle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: _preferredHeight,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
            gradient: LinearGradient(
              colors: <Color>[
                gradientBegin,
                gradientEnd,
              ],
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 10.0,
              fontSize: 30.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Positioned(
          child: Container(
            padding: const EdgeInsets.only(top: 25),
            child: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: toggle),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_preferredHeight);
}

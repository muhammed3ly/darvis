import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final double _preferredHeight = 100.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: _preferredHeight,
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(0.0, 1.0),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
//              Container(
//                margin: const EdgeInsets.only(right: 10),
//                child: IconButton(
//                  icon: Icon(
//                    Icons.menu,
//                    color: Color.fromRGBO(53, 77, 176, 1),
//                    size: 35 * MediaQuery.of(context).textScaleFactor,
//                  ),
//                  onPressed: openDrawer,
//                ),
//              ),
              Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'DARVIS',
                      style: TextStyle(
                        color: Color.fromRGBO(53, 77, 176, 1),
                        fontSize: 30.0,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'C H A T B O T',
                      style: TextStyle(
                        color: Color.fromRGBO(92, 92, 92, 1),
                        fontSize: 14.0,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Image.asset(
                'assets/images/Asset 01.png',
                fit: BoxFit.fitWidth,
                width: MediaQuery.of(context).size.width * 0.28,
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_preferredHeight);
}

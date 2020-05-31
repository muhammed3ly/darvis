import 'package:flutter/material.dart';

class ChatScreenHeader extends StatelessWidget {
  final _headerHeight;
  ChatScreenHeader(this._headerHeight);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: _headerHeight,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 26,
                backgroundImage: NetworkImage(
                    'https://widgetwhats.com/app/uploads/2019/11/free-profile-photo-whatsapp-4.png'),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Muhammed Aly',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'active 3 minutes ago',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.bug_report,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bot/providers/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreenHeader extends StatelessWidget {
  final Function toggle;
  final _headerHeight;
  ChatScreenHeader(this._headerHeight, this.toggle);
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
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: toggle,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 26,
                backgroundImage: Provider.of<User>(context)
                        .chatBotImageUrl
                        .contains('assets')
                    ? AssetImage(Provider.of<User>(context).chatBotImageUrl)
                    : CachedNetworkImageProvider(
                        Provider.of<User>(context).chatBotImageUrl),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Provider.of<User>(context).chatBotName,
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

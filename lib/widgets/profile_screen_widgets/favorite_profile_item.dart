import 'package:chat_bot/providers/categories.dart';
import 'package:chat_bot/providers/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteProfileItem extends StatelessWidget {
  final int id;
  final String title;
  FavoriteProfileItem({
    @required this.id,
    @required this.title,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            this.title,
            style: TextStyle(
              color: Color.fromRGBO(53, 77, 175, 1),
              fontSize: 12,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () {
              Provider.of<Categories>(context).toggleFavorite(
                id,
                true,
                Provider.of<User>(context).userId,
              );
            },
            child: Icon(
              Icons.close,
              size: 20,
              color: Colors.red[800],
            ),
          ),
        ],
      ),
    );
  }
}

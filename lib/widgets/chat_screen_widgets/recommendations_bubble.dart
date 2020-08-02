import 'package:flutter/material.dart';

import 'recommendation_box.dart';

class RecommendationsBubble extends StatelessWidget {
  final String _message;
  final List<dynamic> _responseItems;
  RecommendationsBubble(this._message, this._responseItems);
  @override
  Widget build(BuildContext context) {
    double _space = 7.0;
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: _space),
            width: MediaQuery.of(context).size.width,
            height: 350,
            decoration: BoxDecoration(
              color: Color.fromRGBO(179, 223, 246, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_message),
                Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: _responseItems.length,
                    itemBuilder: (context, i) {
                      return RecommendationBox(_responseItems[i]);
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RecommendationBox extends StatefulWidget {
  final _itemData;

  RecommendationBox(this._itemData);

  @override
  _RecommendationBoxState createState() => _RecommendationBoxState();
}

class _RecommendationBoxState extends State<RecommendationBox>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final rating = double.parse(widget._itemData['imdbRating']) / 2.0;
    return Container(
      margin: const EdgeInsets.all(5),
      width: 200,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              child: Container(
                width: double.infinity,
                child: Image.network(
                  widget._itemData['Poster'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget._itemData['Title'],
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              )),
          Expanded(
            flex: 1,
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  children: <Widget>[
                    RatingBar(
                      initialRating: rating,
                      maxRating: rating,
                      minRating: rating,
                      tapOnlyMode: true,
                      ignoreGestures: true,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    Text(
                      '${widget._itemData['imdbRating']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

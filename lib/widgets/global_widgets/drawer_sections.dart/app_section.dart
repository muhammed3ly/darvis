import 'package:chat_bot/widgets/global_widgets/drawer_sections.dart/send_feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppSection extends StatefulWidget {
  @override
  _AppSectionState createState() => _AppSectionState();
}

class _AppSectionState extends State<AppSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(221, 220, 240, 1),
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          Text(
            'Theme Design',
            style: TextStyle(
              color: Color.fromRGBO(53, 77, 175, 1),
              fontSize: 18 * MediaQuery.of(context).textScaleFactor,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {},
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.2,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(249, 103, 39, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.wb_sunny,
                    size: 28 * MediaQuery.of(context).textScaleFactor,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.2,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(209, 209, 209, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    FontAwesomeIcons.solidMoon,
                    size: 24 * MediaQuery.of(context).textScaleFactor,
                    color: Color.fromRGBO(146, 151, 185, 1),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Ratings/Feedback',
            style: TextStyle(
              color: Color.fromRGBO(53, 77, 175, 1),
              fontSize: 18 * MediaQuery.of(context).textScaleFactor,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.fromRGBO(221, 220, 240, 1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Hero(
              tag: 'rating',
              child: RatingBar(
                initialRating: 0, //TODO: a5er rating hwa 7ato
                tapOnlyMode: true,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                unratedColor: Colors.white,
                itemSize: 30 * MediaQuery.of(context).textScaleFactor,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (_, __, ___) => SendFeedback(rating)));
                },
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.facebook,
                color: Color.fromRGBO(66, 103, 178, 1),
                size: 30 * MediaQuery.of(context).textScaleFactor,
              ),
              SizedBox(
                width: 15,
              ),
              Icon(
                FontAwesomeIcons.instagram,
                color: Color.fromRGBO(193, 53, 132, 1),
                size: 30 * MediaQuery.of(context).textScaleFactor,
              ),
              SizedBox(
                width: 15,
              ),
              Icon(
                FontAwesomeIcons.twitter,
                color: Color.fromRGBO(29, 161, 242, 1),
                size: 30 * MediaQuery.of(context).textScaleFactor,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

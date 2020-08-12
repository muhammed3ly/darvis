import 'package:chat_bot/widgets/global_widgets/custom_appbar.dart';
import 'package:chat_bot/widgets/global_widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class MovieDetailsScreen extends StatefulWidget {
  static const String routeName = '/movie';
  final String heroTag;
  final dynamic movie;
  final List likeThis;
  MovieDetailsScreen(this.movie, this.likeThis, this.heroTag);
  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  List likeThisFiltered;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(243, 240, 248, 1),
      drawer: CustomDrawer(),
      appBar: CustomAppbar(title: 'Movies', openDrawer: drawer),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 30 * MediaQuery.of(context).textScaleFactor,
                    color: Color.fromRGBO(53, 77, 175, 1),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    widget.movie['Title'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25 * MediaQuery.of(context).textScaleFactor,
                      color: Color.fromRGBO(77, 77, 77, 1),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.movie['imdbRating'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25 * MediaQuery.of(context).textScaleFactor,
                          color: Color.fromRGBO(53, 77, 175, 1),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 3,
                        ),
                        child: Text(
                          ' /10',
                          style: TextStyle(
                            color: Color.fromRGBO(77, 77, 77, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: widget.heroTag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Image.network(
                      widget.movie['Poster'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: 15,
            ),
            child: Wrap(
              children: [
                Text(
                  widget.movie['Plot'],
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(53, 77, 175, 1),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.white,
            thickness: 2.0,
          ),
          SizedBox(
            height: 25,
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.07,
              vertical: 5,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Released:',
                  style: TextStyle(
                    color: Color.fromRGBO(77, 77, 77, 1),
                    fontSize: 18 * MediaQuery.of(context).textScaleFactor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    widget.movie['Released'],
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 16 * MediaQuery.of(context).textScaleFactor,
                      color: Color.fromRGBO(53, 77, 175, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.07,
              vertical: 5,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Duration:',
                  style: TextStyle(
                    color: Color.fromRGBO(77, 77, 77, 1),
                    fontSize: 18 * MediaQuery.of(context).textScaleFactor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    widget.movie['Runtime'],
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 16 * MediaQuery.of(context).textScaleFactor,
                      color: Color.fromRGBO(53, 77, 175, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.07,
              vertical: 5,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Director:',
                  style: TextStyle(
                    color: Color.fromRGBO(77, 77, 77, 1),
                    fontSize: 18 * MediaQuery.of(context).textScaleFactor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    widget.movie['Director'],
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 16 * MediaQuery.of(context).textScaleFactor,
                      color: Color.fromRGBO(53, 77, 175, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.07,
              vertical: 5,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Writers:',
                  style: TextStyle(
                    color: Color.fromRGBO(77, 77, 77, 1),
                    fontSize: 18 * MediaQuery.of(context).textScaleFactor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    widget.movie['Writer'],
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 16 * MediaQuery.of(context).textScaleFactor,
                      color: Color.fromRGBO(53, 77, 175, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.07,
              vertical: 5,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Stars:',
                  style: TextStyle(
                    color: Color.fromRGBO(77, 77, 77, 1),
                    fontSize: 18 * MediaQuery.of(context).textScaleFactor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    widget.movie['Actors'],
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 16 * MediaQuery.of(context).textScaleFactor,
                      color: Color.fromRGBO(53, 77, 175, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Divider(
            color: Colors.white,
            thickness: 2.0,
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.07,
            ),
            child: Text(
              'More Like This:',
              style: TextStyle(
                color: Color.fromRGBO(77, 77, 77, 1),
                fontSize: 18 * MediaQuery.of(context).textScaleFactor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: likeThisFiltered.length,
                itemBuilder: (_, i) {
                  String heroTag = likeThisFiltered[i]['imdbID'] +
                      DateTime.now().toIso8601String();
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => MovieDetailsScreen(
                            likeThisFiltered[i],
                            widget.likeThis,
                            heroTag,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        right: 10,
                        left: i == 0
                            ? MediaQuery.of(context).size.width * 0.07
                            : 0,
                      ),
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 6,
                            child: Hero(
                              tag: heroTag,
                              child: Container(
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image.network(
                                    likeThisFiltered[i]['Poster'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                likeThisFiltered[i]['Title'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }

  void drawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  @override
  void initState() {
    super.initState();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    likeThisFiltered = widget.likeThis
        .where((element) => element['imdbID'] != widget.movie['imdbID'])
        .toList();
  }
}

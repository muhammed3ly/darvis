import 'package:chat_bot/providers/users.dart';
import 'package:chat_bot/widgets/global_widgets/custom_appbar.dart';
import 'package:chat_bot/widgets/global_widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';

class MyFavoritesScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  _MyFavoritesScreenState createState() => _MyFavoritesScreenState();
}

class _MyFavoritesScreenState extends State<MyFavoritesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void drawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 240, 248, 1),
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      drawer: CustomDrawer(),
      appBar: CustomAppbar(title: 'Genres', openDrawer: drawer),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Consumer<Categories>(
                  builder: (_, categories, ch) => categories.categories == null
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : GridView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                              top: 16, bottom: 8, right: 8, left: 8),
                          itemCount: categories.categories.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.6,
                            crossAxisSpacing: 40,
                          ),
                          itemBuilder: (ctx, idx) {
                            return Column(
                              children: [
                                Flexible(
                                  flex: 13,
                                  child: Container(
//                                    height: MediaQuery.of(context).size.height *
//                                        0.25,
                                    key: ValueKey(
                                        categories.categories[idx]['name']),
                                    child: GestureDetector(
                                      onTap: () => categories.toggleFavorite(
                                        idx,
                                        true,
                                        Provider.of<User>(context).userId,
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: Image.network(
                                              categories.categories[idx]
                                                  ['imageUrl'],
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: AnimatedOpacity(
                                              duration:
                                                  Duration(milliseconds: 200),
                                              child: Container(
                                                color: Colors.blueAccent,
                                              ),
                                              opacity:
                                                  categories.categories[idx]
                                                              ['isFav'] ==
                                                          'true'
                                                      ? 0.6
                                                      : 0,
                                            ),
                                          ),
                                          Icon(
                                            Icons.favorite_border,
                                            size: categories.categories[idx]
                                                        ['isFav'] ==
                                                    'true'
                                                ? 70
                                                : 0,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 5,
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  child: Text(
                                    categories.categories[idx]['name'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(77, 75, 78, 1),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 5,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

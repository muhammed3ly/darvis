import 'package:chat_bot/screens/temp_splash.dart';
import 'package:chat_bot/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';
import '../providers/users.dart';

class MyFavoritesScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  _MyFavoritesScreenState createState() => _MyFavoritesScreenState();
}

class _MyFavoritesScreenState extends State<MyFavoritesScreen> {
  bool isLoading = false, firstRun = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void drawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstRun) {
      Provider.of<User>(context, listen: false).loadData().then((cats) {
        Provider.of<Categories>(context, listen: false).set(cats);
        setState(() {
          firstRun = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<User>(context, listen: false).userId;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return firstRun
        ? TempSplashScreen()
        : Scaffold(
            key: _scaffoldKey,
            extendBodyBehindAppBar: true,
            drawer: Drawer(),
            appBar: CustomAppbar(title: 'Genres', openDrawer: drawer),
            body: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(3, 155, 229, 1),
                          Colors.black87,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0, 1],
                      ),
                    ),
                    child: Consumer<Categories>(
                      builder: (_, categories, ch) => categories.categories ==
                              null
                          ? Center(child: CircularProgressIndicator())
                          : Padding(
                              padding: EdgeInsets.all(10),
                              child: GridView.builder(
                                itemCount: categories.categories.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                ),
                                itemBuilder: (ctx, idx) {
                                  return GridTile(
                                    footer: GridTileBar(
                                      backgroundColor: Colors.black54,
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            categories.categories[idx]['name'],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                categories.toggleFavorite(
                                                    idx, true, userId),
                                            child: Icon(
                                              categories.categories[idx]
                                                          ['isFav'] ==
                                                      'true'
                                                  ? Icons.star
                                                  : Icons.star_border,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    child: Image.network(
                                      categories.categories[idx]['imageUrl'],
                                      fit: BoxFit.fill,
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                  ),
          );
  }
}

import 'package:chat_bot/screens/temp_splash.dart';
import 'package:chat_bot/widgets/global_widgets/custom_appbar.dart';
import 'package:chat_bot/widgets/global_widgets/custom_drawer.dart';
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
            drawer: CustomDrawer(),
            appBar: CustomAppbar(title: 'Genres', openDrawer: drawer),
            body: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SafeArea(
                  child: Container(
                      height: MediaQuery.of(context).size.height ,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Consumer<Categories>(
                              builder: (_, categories, ch) => categories
                                          .categories ==
                                      null
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : GridView.builder(
                                      padding: EdgeInsets.only(
                                          top: 16, bottom: 8, right: 8, left: 8),
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      itemCount: categories.categories.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.9,
                                        crossAxisSpacing: 40,
                                        mainAxisSpacing: 20,
                                      ),
                                      itemBuilder: (ctx, idx) {
                                        return Column(
                                          children: [
                                            Container(
                                              height: 130,
                                              key: ValueKey(categories
                                                  .categories[idx]['name']),
                                              child: GestureDetector(
                                                onTap: () => categories
                                                    .toggleFavorite(idx),
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: <Widget>[
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      child: Image.network(
                                                        categories.categories[idx]
                                                            ['imageUrl'],
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      child: Opacity(
                                                        child: Container(
                                                          color:
                                                              Colors.blueAccent,
                                                        ),
                                                        opacity:
                                                            categories.categories[
                                                                            idx][
                                                                        'isFav'] ==
                                                                    'true'
                                                                ? 0.6
                                                                : 0,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons.favorite_border,
                                                      size: categories.categories[
                                                                  idx]['isFav'] ==
                                                              'true'
                                                          ? 70
                                                          : 0,
                                                      color: Colors.white,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              categories.categories[idx]['name'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Color.fromRGBO(77, 75, 78, 1),
                                                fontSize: 20,
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

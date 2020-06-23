import 'package:chat_bot/widgets/gradient_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';
import '../providers/users.dart';

class MyFavoritesScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  final Function toggle;

  MyFavoritesScreen({@required this.toggle});

  @override
  _MyFavoritesScreenState createState() => _MyFavoritesScreenState();
}

class _MyFavoritesScreenState extends State<MyFavoritesScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<User>(context, listen: false).userId;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GradientAppBar(
        title: 'Genres',
        gradientBegin: Color.fromRGBO(3, 155, 229, 1),
        gradientEnd: Colors.black,
        toggle: widget.toggle,
      ),
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
                builder: (_, categories, ch) => categories.categories == null
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
                                      onTap: () => categories.toggleFavorite(
                                          idx, true, userId),
                                      child: Icon(
                                        categories.categories[idx]['isFav'] ==
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

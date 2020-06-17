import 'package:chat_bot/widgets/gradient_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';
import '../providers/users.dart';
import '../widgets/Drawer.dart';

class MyFavoritesScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  bool signUp;
  final Function toggle;
  MyFavoritesScreen({this.signUp = false, @required this.toggle});

  @override
  _MyFavoritesScreenState createState() => _MyFavoritesScreenState();
}

class _MyFavoritesScreenState extends State<MyFavoritesScreen> {
  bool first = true;

  Future<void> init() async {
    print('init here');
    if (first) {
      first = false;
      final user = await FirebaseAuth.instance.currentUser();
      final userData =
          await Firestore.instance.collection('users').document(user.uid).get();
      userData.documentID;

      Provider.of<User>(context, listen: false).setData(
          user.email, userData['userName'], userData['imageUrl'], user.uid);
      final allDocuments = await Firestore.instance
          .collection('users')
          .document(user.uid)
          .collection('categories')
          .getDocuments();

      Provider.of<Categories>(context, listen: false)
          .set(allDocuments.documents.map((document) {
        return {
          'name': document.documentID as String,
          'imageUrl': document.data['imageUrl'] as String,
          'isFav': document.data['isFav'] as String,
        };
      }).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.signUp) init();
    print('hahahahah');
    String userId = Provider.of<User>(context, listen: false).userId;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GradientAppBar(
        title: 'Favorites',
        gradientBegin: Color.fromRGBO(3, 155, 229, 1),
        gradientEnd: Colors.black,
        toggle: widget.toggle,
      ),
      body: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.only(top: 80),
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  categories.categories[idx]['isFav'] == 'true'
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

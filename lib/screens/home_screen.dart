import 'package:chat_bot/widgets/Drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../providers/categories.dart';
import 'package:provider/provider.dart';
import '../providers/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  bool signUp = false;

  HomeScreen({this.signUp});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool first = true;

  Future<void> init() async {
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
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Favorite Categories'),
      ),
      body: Consumer<Categories>(
        builder: (_, categories, ch) => categories.categories == null
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
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
                            onTap: () =>
                                categories.toggleFavorite(idx, true, userId),
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
    );
  }
}

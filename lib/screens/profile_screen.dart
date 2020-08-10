import 'dart:io';

import 'package:chat_bot/providers/categories.dart';
import 'package:chat_bot/providers/users.dart';
import 'package:chat_bot/widgets/global_widgets/custom_appbar.dart';
import 'package:chat_bot/widgets/global_widgets/custom_drawer.dart';
import 'package:chat_bot/widgets/profile_screen_widgets/favorite_profile_item.dart';
import 'package:chat_bot/widgets/profile_screen_widgets/profile_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(243, 240, 248, 1),
      appBar: CustomAppbar(title: 'Profile', openDrawer: drawer),
      drawer: CustomDrawer(),
      body: Container(
        margin: const EdgeInsets.only(top: 30),
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 90,
                  backgroundImage:
                      Provider.of<User>(context).imageUrl == 'default'
                          ? AssetImage('assets/images/Author__Placeholder.png')
                          : NetworkImage(
                              Provider.of<User>(context).imageUrl,
                            ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton.icon(
                  color: Colors.white,
                  shape: StadiumBorder(),
                  icon: Icon(
                    Icons.camera_alt,
                    color: Color.fromRGBO(53, 77, 175, 1),
                  ),
                  label: Text(
                    'Open Camera',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  onPressed: () => _changeProfilePhoto(1),
                ),
                SizedBox(
                  width: 10,
                ),
                FlatButton.icon(
                  color: Colors.white,
                  shape: StadiumBorder(),
                  icon: Icon(
                    FontAwesomeIcons.images,
                    color: Color.fromRGBO(53, 77, 175, 1),
                  ),
                  label: Text(
                    'From Gallery',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  onPressed: () => _changeProfilePhoto(0),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            SizedBox(
              height: 15,
            ),
            Hero(
              tag: 'Email',
              child: Material(
                color: Colors.transparent,
                child: ProfileItem(
                  title: 'Email Address',
                  value: Provider.of<User>(context).email,
                  editFunction: _changeEmail,
                ),
              ),
            ),
            ProfileItem(
              title: 'User Name',
              value: Provider.of<User>(context).userName,
              editFunction: _changeName,
            ),
            Hero(
              tag: 'Password',
              child: Material(
                color: Colors.transparent,
                child: ProfileItem(
                  title: 'Password',
                  value: '********',
                  editFunction: _changePassword,
                  password: true,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Divider(
              color: Colors.white,
              thickness: 2.0,
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.12,
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.heart,
                    color: Color.fromRGBO(53, 77, 175, 1),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Favorites',
                    style: TextStyle(
                      fontSize: 20 * MediaQuery.of(context).textScaleFactor,
                      color: Color.fromRGBO(53, 77, 175, 1),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Provider.of<Categories>(context).favs.length > 0
                  ? Wrap(
                      spacing: 10,
                      children: Provider.of<Categories>(context).favs.map(
                        (e) {
                          return FavoriteProfileItem(
                            id: e['index'],
                            title: e['name'],
                          );
                        },
                      ).toList(),
                    )
                  : Text(
                      'No favories.',
                      textAlign: TextAlign.center,
                    ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void drawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  void _changeEmail(String email, String password) async {
    await Provider.of<User>(context, listen: false)
        .changeEmail(email, password);
  }

  void _changeName(String name) async {
    await Provider.of<User>(context, listen: false).updateUserName(name);
  }

  void _changePassword(String oldPassword, String newPassword) async {
    await Provider.of<User>(context, listen: false)
        .updatePassword(oldPassword, newPassword);
  }

  void _changeProfilePhoto(int mode) async {
    PickedFile pickedFile;
    ImagePicker picker = ImagePicker();
    if (mode == 0) {
      pickedFile = await picker.getImage(source: ImageSource.gallery);
    } else {
      pickedFile = await picker.getImage(source: ImageSource.camera);
    }
    if (pickedFile == null) {
      return;
    }
    final File file = File(pickedFile.path);
    await Provider.of<User>(context, listen: false).updateUserImage(file);
  }
}

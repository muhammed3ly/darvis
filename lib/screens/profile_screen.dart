import 'dart:io';

import 'package:chat_bot/providers/users.dart';
import 'package:chat_bot/widgets/custom_appbar.dart';
import 'package:chat_bot/widgets/settings_screen_widgets/bottom_sheets/send_feedback_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../widgets/settings_screen_widgets/bottom_sheets/name_bottom_sheet.dart';
import '../widgets/settings_screen_widgets/bottom_sheets/password.dart';
import '../widgets/settings_screen_widgets/bottom_sheets/profile_picture_bottom_sheet.dart';
import '../widgets/settings_screen_widgets/settings_item.dart';
import '../widgets/settings_screen_widgets/settings_photo_item.dart';
import '../widgets/settings_screen_widgets/settings_section.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<ProfileScreen> {
  MediaQueryData mediaQuery;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void drawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mediaQuery = MediaQuery.of(context);
  }

  Future<void> showCantUpdate(error) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Try again later!'),
        content: Text(error),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _changeProfilePhoto(int mode, bool profile) async {
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
    try {
      if (profile) {
        await Provider.of<User>(context, listen: false).updateUserImage(file);
      } else {
        Provider.of<User>(context, listen: false).updateChatBotImage(file);
      }
    } catch (error) {
      await showCantUpdate(error);
    }
    Navigator.of(context).pop();
  }

  void _changeName(String name, bool user) async {
    try {
      if (user) {
        await Provider.of<User>(context, listen: false).updateUserName(name);
      } else {
        await Provider.of<User>(context, listen: false).updateChatBotName(name);
      }
    } catch (error) {
      await showCantUpdate(error);
    }
    Navigator.of(context).pop();
  }

  void _changePassword(String password) async {
    try {
      await Provider.of<User>(context, listen: false).updatePassword(password);
    } catch (error) {
      await showCantUpdate(error);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: _scaffoldKey,
      appBar: CustomAppbar(title: 'Profile', openDrawer: drawer),
      body: Consumer<User>(
        builder: (_, user, __) => SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 80),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(3, 155, 229, 1),
                  Colors.black,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
            child: Column(
              children: <Widget>[
                SettingsSection(
                  title: 'My Profile',
                  children: <Widget>[
                    SettingsPhotoItem(
                      user.imageUrl,
                      () {},
                    ),
                    SettingsItem(
                      title: 'Username',
                      subtitle: user.userName,
                      fun: () {},
                    ),
                    SettingsItem(
                      title: 'Change Password',
                      fun: () {},
                    ),
                  ],
                ),
                SettingsSection(
                  title: 'Chatbot Profile',
                  children: <Widget>[
                    SettingsPhotoItem(
                      user.chatBotImageUrl,
                      () {},
                    ),
                    SettingsItem(
                      title: 'Chatbot Name',
                      subtitle: user.chatBotName,
                      fun: () {},
                    ),
                    SettingsItem(
                      title: 'Reset Chat',
                      icon: Icons.refresh,
                      fun: () {},
                    ),
                  ],
                ),
                SettingsSection(
                  title: 'Application',
                  children: <Widget>[
                    SettingsItem(
                      title: 'Change Theme',
                      subtitle: 'Light theme',
                      fun: () {},
                    ),
                    SettingsItem(
                      title: 'Send Feedback',
                      icon: Icons.report,
                      fun: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

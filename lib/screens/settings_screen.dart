import 'dart:io';

import 'package:chat_bot/providers/users.dart';
import 'package:chat_bot/widgets/settings_screen_widgets/bottom_sheets/send_feedback_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../widgets/gradient_appbar.dart';
import '../widgets/settings_screen_widgets/bottom_sheets/name_bottom_sheet.dart';
import '../widgets/settings_screen_widgets/bottom_sheets/password.dart';
import '../widgets/settings_screen_widgets/bottom_sheets/profile_picture_bottom_sheet.dart';
import '../widgets/settings_screen_widgets/settings_item.dart';
import '../widgets/settings_screen_widgets/settings_photo_item.dart';
import '../widgets/settings_screen_widgets/settings_section.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';
  final Function toggle;
  SettingsScreen(this.toggle);
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  MediaQueryData mediaQuery;
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
        ));
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

  void _resetChat() async {
    try {
      final respone = await showDialog(
        barrierDismissible: false,
        context: context,
        child: SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text('Are you sure you want to clear the chat?'),
          children: <Widget>[
            SimpleDialogOption(
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Yes',
                    style: TextStyle(color: Colors.green),
                  )
                ],
              ),
              onPressed: () => Navigator.of(context).pop(true),
            ),
            SimpleDialogOption(
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'No',
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        ),
      );
      if (respone) {
        await Provider.of<User>(context, listen: false).resetChat();
      }
    } catch (error) {
      await showCantUpdate(error);
    }
  }

  void _sendFeedback(String feedback) async {
    try {
      await Provider.of<User>(context, listen: false).sendFeedback(feedback);
    } catch (error) {
      await showCantUpdate(error);
    }
    Navigator.of(context).pop();
  }

  void _modalBottomSheetMenu(Widget sheetDetails) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.black.withOpacity(0),
        builder: (builder) {
          return sheetDetails;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GradientAppBar(
        title: 'SETTINGS',
        gradientBegin: Color.fromRGBO(3, 155, 229, 1),
        gradientEnd: Colors.black,
        toggle: widget.toggle,
      ),
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
                      () => _modalBottomSheetMenu(
                          ProfilePictureBottomSheet(_changeProfilePhoto, true)),
                    ),
                    SettingsItem(
                      title: 'Username',
                      subtitle: user.userName,
                      fun: () => _modalBottomSheetMenu(
                        NameBottomSheet(_changeName, user.userName, true),
                      ),
                    ),
                    SettingsItem(
                      title: 'Change Password',
                      fun: () => _modalBottomSheetMenu(
                          ChangePassword(_changePassword)),
                    ),
                  ],
                ),
                SettingsSection(
                  title: 'Chatbot Profile',
                  children: <Widget>[
                    SettingsPhotoItem(
                      user.chatBotImageUrl,
                      () => _modalBottomSheetMenu(ProfilePictureBottomSheet(
                          _changeProfilePhoto, false)),
                    ),
                    SettingsItem(
                      title: 'Chatbot Name',
                      subtitle: user.chatBotName,
                      fun: () => _modalBottomSheetMenu(
                        NameBottomSheet(_changeName, user.chatBotName, false),
                      ),
                    ),
                    SettingsItem(
                      title: 'Reset Chat',
                      icon: Icons.refresh,
                      fun: _resetChat,
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
                      fun: () => _modalBottomSheetMenu(
                        SendFeedbackSheet(_sendFeedback),
                      ),
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

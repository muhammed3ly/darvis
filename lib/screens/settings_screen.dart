import 'dart:io';

import 'package:darvis/widgets/settings_screen_widgets/bottom_sheets/name_bottom_sheet.dart';
import 'package:darvis/widgets/settings_screen_widgets/bottom_sheets/password.dart';
import 'package:darvis/widgets/settings_screen_widgets/bottom_sheets/profile_picture_bottom_sheet.dart';
import 'package:darvis/widgets/settings_screen_widgets/settings_item.dart';
import 'package:darvis/widgets/settings_screen_widgets/settings_section.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  MediaQueryData mediaQuery;
  File _pickedImage;
  String _profileUserName = "Muhammed Aly";
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mediaQuery = MediaQuery.of(context);
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
    if (profile) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    } else {
      //TODO: do some work to change chatbot photo
      print('Change chatbot photo');
    }
    Navigator.of(context).pop();
  }

  void _changeUserName(String userName) {
    setState(() {
      _profileUserName = userName;
    });
    Navigator.of(context).pop();
  }

  void _changePassword(String password) {
    //TODO: do some work to change the password
  }
  void _modalBottomSheetMenu(Widget sheetDetails) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return sheetDetails;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10),
                height:
                    (mediaQuery.size.height - mediaQuery.padding.top) * 0.45,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 6),
                      width: mediaQuery.size.width * 0.6 + 10,
                      height: mediaQuery.size.width * 0.6 + 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
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
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: CircleAvatar(
                        radius: mediaQuery.size.width * 0.3,
                        backgroundImage: _pickedImage == null
                            ? NetworkImage(
                                'https://widgetwhats.com/app/uploads/2019/11/free-profile-photo-whatsapp-4.png',
                              )
                            : FileImage(_pickedImage),
                      ),
                    ),
                    Positioned(
                      bottom: -5,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 40,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              size: 30,
                            ),
                            onPressed: () => _modalBottomSheetMenu(
                              ProfilePictureBottomSheet(
                                _changeProfilePhoto,
                                true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SettingsSection(
                title: 'My Profle',
                children: <Widget>[
                  SettingsItem(
                    title: 'Username',
                    subtitle: _profileUserName,
                    fun: () => _modalBottomSheetMenu(
                        NameBottomSheet(_changeUserName, _profileUserName)),
                  ),
                  SettingsItem(
                    title: 'Change Password',
                    fun: () =>
                        _modalBottomSheetMenu(ChangePassword(_changePassword)),
                  ),
                  SettingsItem(
                    title: 'Forgot Password',
                    icon: Icons.restore,
                    fun: () {},
                  ),
                ],
              ),
              SettingsSection(
                title: 'Chatbot Profile',
                children: <Widget>[
                  SettingsItem(
                    title: 'Chatbot Name',
                    subtitle: 'Akram',
                    fun: () {},
                  ),
                  SettingsItem(
                    title: 'Chatbot Photo',
                    fun: () => _modalBottomSheetMenu(
                      ProfilePictureBottomSheet(
                        _changeProfilePhoto,
                        true,
                      ),
                    ),
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
    );
  }
}

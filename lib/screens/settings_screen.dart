import '../widgets/gradient_appbar.dart';
import '../widgets/settings_screen_widgets/bottom_sheets/name_bottom_sheet.dart';
import '../widgets/settings_screen_widgets/bottom_sheets/password.dart';
import '../widgets/settings_screen_widgets/bottom_sheets/profile_picture_bottom_sheet.dart';
import '../widgets/settings_screen_widgets/settings_item.dart';
import '../widgets/settings_screen_widgets/settings_photo_item.dart';
import '../widgets/settings_screen_widgets/settings_section.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';
  final Function toggle;
  SettingsScreen(this.toggle);
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  MediaQueryData mediaQuery;
  String _profileUserName = "Muhammed Aly";
  String _profilePicture = 'assets/images/default-user-placeholder.png';
  String _chatbotImage = 'assets/images/chatbot.png';
  String _chatbotName = 'Akram';
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
      //TODO: do some work to change profile picture
    } else {
      //TODO: do some work to change chatbot photo
      print('Change chatbot photo');
    }
    Navigator.of(context).pop();
  }

  void _changeName(String name, bool user) {
    setState(() {
      if (user) {
        _profileUserName = name;
      } else {
        _chatbotName = name;
      }
    });
    Navigator.of(context).pop();
  }

  void _changePassword(String password) {
    //TODO: do some work to change the password
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 80),
          decoration: BoxDecoration(
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
                    _profilePicture,
                    () => _modalBottomSheetMenu(
                        ProfilePictureBottomSheet(_changeProfilePhoto, true)),
                  ),
                  SettingsItem(
                    title: 'Username',
                    subtitle: _profileUserName,
                    fun: () => _modalBottomSheetMenu(
                      NameBottomSheet(_changeName, _profileUserName, true),
                    ),
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
                  SettingsPhotoItem(
                    _chatbotImage,
                    () => _modalBottomSheetMenu(
                        ProfilePictureBottomSheet(_changeProfilePhoto, false)),
                  ),
                  SettingsItem(
                    title: 'Chatbot Name',
                    subtitle: _chatbotName,
                    fun: () => _modalBottomSheetMenu(
                      NameBottomSheet(_changeName, _chatbotName, false),
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

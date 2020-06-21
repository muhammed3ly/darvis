import 'package:chat_bot/providers/categories.dart';
import 'package:chat_bot/providers/users.dart';
import 'package:chat_bot/screens/my_favorites.dart';
import 'package:chat_bot/screens/temp_splash.dart';
import 'package:provider/provider.dart';

import '../screens/chat_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/drawer_content.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'package:swipedetector/swipedetector.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';
  var tog;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<User>(context, listen: false).loadData(),
      builder: (ctx, snapShot) {
        if (snapShot.hasData) {
          Provider.of<Categories>(ctx, listen: false).set(snapShot.data);
          return SimpleHiddenDrawer(
            menu: HiddenDrawer(),
            screenSelectedBuilder: (position, controller) {
              void toggle() {
                tog = controller;
                controller.toggle();
              }

              Widget screenCurrent;

              switch (position) {
                case 0:
                  screenCurrent = MyFavoritesScreen(
                    toggle: toggle,
                  );
                  break;
                case 1:
                  screenCurrent = ChatScreen(toggle);
                  break;
                case 2:
                  screenCurrent = SettingsScreen(toggle);
              }

              return SwipeDetector(
                onSwipeLeft: () => controller.toggle(),
                onSwipeRight: () => controller.toggle(),
                child: screenCurrent,
              );
            },
          );
        } else {
          return TempSplashScreen();
        }
      },
    );
  }
}

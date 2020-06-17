import 'package:chat_bot/screens/my_favorites.dart';

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
  }
}

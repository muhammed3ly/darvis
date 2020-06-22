import 'package:chat_bot/screens/chat_screen.dart';
import 'package:chat_bot/screens/my_favorites.dart';
import 'package:chat_bot/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/simple_hidden_drawer/simple_hidden_drawer.dart';
import 'package:swipedetector/swipedetector.dart';

import 'drawer_content.dart';

class HomeNavigator extends StatelessWidget {
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

import 'package:darvis/screens/chat_screen.dart';
import 'package:darvis/screens/settings_screen.dart';
import 'package:darvis/widgets/drawer_content.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'package:swipedetector/swipedetector.dart';

class HomeScreen extends StatelessWidget {
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
            screenCurrent = ChatScreen(toggle);
            break;
          case 1:
            screenCurrent = SettingsScreen(toggle);
            break;
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

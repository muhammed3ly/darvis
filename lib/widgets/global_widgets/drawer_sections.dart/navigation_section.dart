import 'package:chat_bot/widgets/global_widgets/drawer_sections.dart/chat_navigation_section.dart';
import 'package:chat_bot/widgets/global_widgets/drawer_sections.dart/navigation_section_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavigationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(221, 220, 240, 1),
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          NavigationSectionItem(
            icon: Icons.person,
            title: 'Profile',
            onTap: () {
              debugPrint('profile');
            },
          ),
          NavigationSectionItem(
            icon: FontAwesomeIcons.film,
            title: 'Movies Genres',
            onTap: () {
              debugPrint('Movies Genres');
            },
          ),
          ChatNavigationSectionItem(),
        ],
      ),
    );
  }
}

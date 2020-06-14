import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Function fun;
  SettingsItem(
      {@required this.title,
      this.icon = Icons.edit,
      this.subtitle,
      @required this.fun});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
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
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          subtitle: subtitle == null
              ? null
              : Text(
                  subtitle,
                  style: TextStyle(color: Colors.white),
                ),
          trailing: IconButton(
              icon: Icon(
                icon,
                color: Colors.white,
              ),
              onPressed: fun),
        ),
      ),
    );
  }
}

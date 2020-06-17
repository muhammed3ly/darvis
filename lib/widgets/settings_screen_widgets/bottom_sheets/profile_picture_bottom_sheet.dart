import 'package:flutter/material.dart';

class ProfilePictureBottomSheet extends StatelessWidget {
  final Function _getPhoto;
  final bool _changeProfilePhoto;
  ProfilePictureBottomSheet(this._getPhoto, this._changeProfilePhoto);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.photo_library, size: 32, color: Colors.white),
                onPressed: () => _getPhoto(0, _changeProfilePhoto),
              ),
              Text(
                'Gallery',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.photo_camera,
                  size: 32,
                  color: Colors.white,
                ),
                onPressed: () => _getPhoto(1, _changeProfilePhoto),
              ),
              Text(
                'Camera',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

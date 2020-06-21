import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SettingsPhotoItem extends StatelessWidget {
  final String image;
  final Function changePhoto;
  SettingsPhotoItem(this.image, this.changePhoto);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 70,
            backgroundColor: Color.fromRGBO(20, 74, 100, 1),
            child: CircleAvatar(
              radius: 65,
              backgroundColor: Colors.white,
              backgroundImage: image.contains('assets')
                  ? AssetImage(image)
                  : CachedNetworkImageProvider(image),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Color.fromRGBO(20, 74, 100, 1),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: IconButton(
                  color: Color.fromRGBO(20, 74, 100, 1),
                  icon: Icon(Icons.edit),
                  onPressed: changePhoto,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

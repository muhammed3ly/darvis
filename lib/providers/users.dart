import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User with ChangeNotifier {
  String email, userName, imageUrl, userId;

  void setData(String email, String userName, String imageUrl, String userId) {
    this.email = email;
    this.userName = userName;
    this.imageUrl = imageUrl;
    this.userId = userId;
  }

  void addMessage(String message, bool byMe) {
    Firestore.instance
        .collection('users')
        .document(userId)
        .collection('chats')
        .add(
            {'text': message, 'byMe': byMe, 'time': DateTime.now().toString()});
  }
}

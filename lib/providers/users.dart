import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String text;
  final bool byMe;
  final String time;
  Message({
    @required this.text,
    @required this.byMe,
    @required this.time,
  });
}

class User with ChangeNotifier {
  String email, userName, imageUrl, userId;
  List<Message> _chatMessages = [];
  void setData(String email, String userName, String imageUrl, String userId) {
    this.email = email;
    this.userName = userName;
    this.imageUrl = imageUrl;
    this.userId = userId;
  }

  List<Message> get messages {
    return [..._chatMessages];
  }

  Future<void> addMessage(Message message) async {
    await Firestore.instance
        .collection('users')
        .document(userId)
        .collection('chats')
        .add(
            {'text': message.text, 'byMe': message.byMe, 'time': message.time});
    _chatMessages.add(message);
    notifyListeners();
  }
}

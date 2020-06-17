import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

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
  String chatBotName, chatBotImageUrl;
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

  Future<void> updateUserName(String name) async {
    await Firestore.instance
        .collection('users')
        .document(userId)
        .setData({'userName': name.trim()}, merge: true);
    userName = name.trim();
    notifyListeners();
  }

  Future<void> updatePassword(String newPassword) async {
    final user = await FirebaseAuth.instance.currentUser();
    await user.updatePassword(newPassword);
  }

  Future<void> updateUserImage(File file) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child(userId + '.jpg');
    await ref.putFile(file).onComplete;
    final url = await ref.getDownloadURL();
    await Firestore.instance
        .collection('users')
        .document(userId)
        .setData({'imageUrl': url}, merge: true);
    imageUrl = url;
    notifyListeners();
  }

  Future<void> updateChatBotImage(File file) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('chatbot_image')
        .child(userId + '_chatbot.jpg');
    await ref.putFile(file).onComplete;
    final url = await ref.getDownloadURL();
    await Firestore.instance
        .collection('users')
        .document(userId)
        .setData({'chatBotImageUrl': url}, merge: true);
    chatBotImageUrl = url;
    notifyListeners();
  }

  Future<void> updateChatBotName(String name) async {
    await Firestore.instance
        .collection('users')
        .document(userId)
        .setData({'chatBotName': name.trim()}, merge: true);
    chatBotName = name.trim();
    notifyListeners();
  }

  Future<void> resetChat() async {
    final msgs = await Firestore.instance
        .collection('users')
        .document(userId)
        .collection('chats')
        .getDocuments();
    msgs.documents.forEach((doc) async {
      await Firestore.instance
          .collection('users')
          .document(userId)
          .collection('chats')
          .document(doc.documentID)
          .delete();
    });
  }

  Future<void> sendFeedback(String text) async {
    await Firestore.instance.collection('feedback').add({
      'userId': userId,
      'feedback': text.trim(),
    });
    Future<void> loadMessage() async {
      _chatMessages = [];
      var messages = await Firestore.instance
          .collection('users')
          .document(userId)
          .collection('chats')
          .orderBy('time', descending: false)
          .getDocuments();
      messages.documents.forEach((message) {
        _chatMessages.add(Message(
            text: message['text'],
            byMe: message['byMe'],
            time: message['time']));
      });
      notifyListeners();
    }
  }
}

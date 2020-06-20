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
  File pickedImage;
  List<Message> _chatMessages = [];
  List<Map<String, String>> categories = [];
  bool isSigning = false;
  bool isLoaded = false;

  void setData(
      {String email,
      String userName,
      String imageUrl,
      String userId,
      File pickedImage,
      List<Map<String, String>> categories}) {
    this.email = email;
    this.userName = userName;
    this.imageUrl = imageUrl;
    this.userId = userId;
    this.pickedImage = pickedImage;
    this.categories = categories;
  }

  Future<List<Map<String, String>>> loadData() async {
    await loadMessage();
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();
    setData(
      userName: userData['userName'],
      email: userData['email'],
      userId: user.uid,
      imageUrl: userData['imageUrl'],
    );
    final allDocuments = await Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('categories')
        .getDocuments();
    return allDocuments.documents.map((document) {
      return {
        'name': document.documentID as String,
        'imageUrl': document.data['imageUrl'] as String,
        'isFav': document.data['isFav'] as String,
      };
    }).toList();
  }

  Future<bool> signUp() async {
    var user = await FirebaseAuth.instance.currentUser();
    userId = user.uid;
    categories.forEach((type) async {
      await Firestore.instance
          .collection('users')
          .document(user.uid)
          .collection('categories')
          .document(type['name'])
          .setData({
        'imageUrl': type['imageUrl'],
        'isFav': type['isFav'],
      });
    });
    final ref = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child(user.uid + '.jpg');
    await ref.putFile(pickedImage).onComplete;
    final url = await ref.getDownloadURL();
    await Firestore.instance.collection('users').document(user.uid).setData({
      'userName': userName,
      'email': email,
      'imageUrl': url,
    });
    return true;
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
  }

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
          text: message['text'], byMe: message['byMe'], time: message['time']));
    });
    notifyListeners();
  }
}

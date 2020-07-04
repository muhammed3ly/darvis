import 'dart:convert' as convert;
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

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
      List<Map<String, String>> categories,
      chatBotImageUrl,
      chatBotName}) {
    this.email = email;
    this.userName = userName;
    this.imageUrl = imageUrl;
    this.userId = userId;
    this.pickedImage = pickedImage;
    this.categories = categories;
    this.chatBotImageUrl = chatBotImageUrl;
    this.chatBotName = chatBotName;
  }

  Future<List<Map<String, String>>> loadData() async {
    if (isLoaded) {
      final allDocuments = await Firestore.instance
          .collection('users')
          .document(userId)
          .collection('categories')
          .getDocuments();
      return allDocuments.documents.map((document) {
        return {
          'name': document.documentID,
          'imageUrl': document.data['imageUrl'] as String,
          'isFav': document.data['isFav'] as String,
        };
      }).toList();
    }
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();
    setData(
      userName: userData['userName'],
      email: userData['email'],
      userId: user.uid,
      imageUrl: userData['imageUrl'],
      chatBotImageUrl: userData['chatBotImageUrl'],
      chatBotName: userData['chatBotName'],
    );
    await loadMessage();
    final allDocuments = await Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('categories')
        .getDocuments();
    return allDocuments.documents.map((document) {
      return {
        'name': document.documentID,
        'imageUrl': document.data['imageUrl'] as String,
        'isFav': document.data['isFav'] as String,
      };
    }).toList();
  }

  Future<void> signUp(String email, String userName, String password,
      File pickedImage, List<Map<String, String>> categories) async {
    isSigning = true;
    notifyListeners();
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    final user = await FirebaseAuth.instance.currentUser();
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
      'chatBotImageUrl': 'assets/images/chatbot.png',
      'chatBotName': 'DARVIS'
    });
    setData(
      email: email,
      userName: userName,
      imageUrl: url,
      userId: user.uid,
      categories: categories,
      chatBotImageUrl: 'assets/images/chatbot.png',
      chatBotName: 'DARVIS',
    );
    isLoaded = true;
    isSigning = false;
    notifyListeners();
  }

  List<Message> get messages {
    return [..._chatMessages];
  }

  Future<void> addMessage(Message message) async {
    _chatMessages.insert(0, message);
    notifyListeners();
    try {
      await Firestore.instance
          .collection('users')
          .document(userId)
          .collection('chats')
          .add({
        'text': message.text,
        'byMe': message.byMe,
        'time': message.time
      });
    } catch (error) {
      _chatMessages.removeAt(0);
      notifyListeners();
      throw Exception(error);
    }
    if (message.byMe) {
      await letDarvisReply(message.text);
    }
  }

  Future<void> letDarvisReply(String text) async {
    AudioCache cache = AudioCache();
    var sound;
    sound = await cache.loop("soundEffects/typing.mp3");
    String url = 'http://3.14.82.117/darvis';
    try {
      final response = await http.post(url,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: convert.jsonEncode({
            'Message': text,
            'NewMessage': 1,
            'Reply': "all",
            'NumberFilms': 10
          }));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = convert.jsonDecode(response.body);
        addMessage(
          new Message(
            text: responseData['Response'],
            byMe: false,
            time: DateTime.now().toIso8601String(),
          ),
        );
        if (responseData['Activated Model'] == 'R') {
          for (int i = 0; i < responseData['Films'].length; i++) {
            addMessage(
              new Message(
                text: responseData['Films'][i].split('\n')[0],
                byMe: false,
                time: DateTime.now().toIso8601String(),
              ),
            );
          }
        }
      } else {
        addMessage(
          new Message(
            text:
                'I can\'t talk now check the internet connection or try again later.',
            byMe: false,
            time: DateTime.now().toIso8601String(),
          ),
        );
      }
    } catch (error) {
      addMessage(
        new Message(
          text:
              'I can\'t talk now check the internet connection or try again later.',
          byMe: false,
          time: DateTime.now().toIso8601String(),
        ),
      );
      print("reply: $error");
    }

    await sound.stop();
    cache.clearCache();
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
    _chatMessages.clear();
    notifyListeners();
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
        .orderBy('time', descending: true)
        .getDocuments();
    messages.documents.forEach((message) {
      _chatMessages.add(Message(
          text: message['text'], byMe: message['byMe'], time: message['time']));
    });
  }
}

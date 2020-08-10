import 'dart:convert' as convert;
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class Message {
  final String text;
  final bool byMe;
  final String time;
  final recommendations;
  Message({
    @required this.text,
    @required this.byMe,
    @required this.time,
    this.recommendations,
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
      email: user.email,
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

  Map<String, dynamic> toMap(rec) {
    return {
      'Title': rec['Title'],
      'Poster': rec['Poster'],
      'imdbRating': rec['imdbRating'],
      'imdbID': rec['imdbID'],
    };
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
        'time': message.time,
        'recommendations': message.recommendations == null
            ? 'null'
            : message.recommendations.map((i) => toMap(i)).toList()
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

  Future<dynamic> getFilmByID(String id) async {
    String url = "http://www.omdbapi.com/?i=$id&apikey=eb4d3f87";
    final response = await http.get(url);
    return convert.jsonDecode(response.body);
  }

  Future<void> letDarvisReply(String text) async {
    AudioCache cache = AudioCache();
    var sound;
    sound = await cache.loop("soundEffects/typing.mp3");
    String url = 'http://3.230.233.147/darvis';
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
        if (responseData['Activated Model'] == 'G') {
          addMessage(
            Message(
              text: responseData['Response'],
              byMe: false,
              time: DateTime.now().toIso8601String(),
            ),
          );
        } else if (responseData['Activated Model'] == 'R') {
          final recs = [];
          for (int i = 0; i < responseData['FilmsIDs'].length; i++) {
            print(responseData['FilmsIDs'][i]);
            recs.add(await getFilmByID(responseData['FilmsIDs'][i]));
          }
          addMessage(
            Message(
              text: responseData['Response'],
              byMe: false,
              time: DateTime.now().toIso8601String(),
              recommendations: recs,
            ),
          );
        }
      } else {
        addMessage(
          Message(
            text:
                'I can\'t talk now check the internet connection or try again later.',
            byMe: false,
            time: DateTime.now().toIso8601String(),
          ),
        );
      }
    } catch (error) {
      addMessage(
        Message(
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
    String oldUserName = userName;
    userName = name.trim();
    notifyListeners();
    try {
      await Firestore.instance
          .collection('users')
          .document(userId)
          .setData({'userName': name.trim()}, merge: true);
    } on PlatformException {
      userName = oldUserName;
      notifyListeners();
      showError(
        'Couldn\'t change username',
        'Please check your internet connection.',
      );
    } catch (error) {
      userName = oldUserName;
      notifyListeners();
      showError(
        'Couldn\'t change username',
        'Please check your internet connection.',
      );
    }
  }

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      AuthCredential authCredential = EmailAuthProvider.getCredential(
        email: user.email,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(authCredential);
      await user.updatePassword(newPassword);
    } on PlatformException {
      showError(
        'Couldn\'t change password',
        'Couldn\'t change password as you entered a wrong current password.',
      );
    } catch (error) {
      showError(
        'Couldn\'t change password',
        'Please check your internet connection.',
      );
    }
  }

  Future<void> changeEmail(String emaill, String password) async {
    try {
      final user = await FirebaseAuth.instance.currentUser();

      this.email = emaill;
      notifyListeners();
      AuthCredential authCredential = EmailAuthProvider.getCredential(
        email: user.email,
        password: password,
      );
      await user.reauthenticateWithCredential(authCredential);
      await user.updateEmail(emaill);
    } on PlatformException catch (error) {
      showError(
        'Couldn\'t change your email',
        error.message == 'ERROR_EMAIL_ALREADY_IN_USE'
            ? 'This email already exists'
            : 'Couldn\'t change email as you entered a wrong current password.',
      );
    } catch (error) {
      showError(
        'Couldn\'t change your email',
        'Please check your internet connection.',
      );
    }
  }

  Future<void> updateUserImage(File file) async {
    String prevImage = this.imageUrl;
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(userId + '.jpg');
      await ref.putFile(file).onComplete;
      final url = await ref.getDownloadURL();
      imageUrl = url;
      notifyListeners();
      await Firestore.instance
          .collection('users')
          .document(userId)
          .setData({'imageUrl': url}, merge: true);
    } on PlatformException {
      this.imageUrl = prevImage;
      notifyListeners();
      showError(
        'Couldn\'t change your image',
        'Please check your internet connection.',
      );
    } catch (error) {
      this.imageUrl = prevImage;
      notifyListeners();
      showError(
        'Couldn\'t change your image',
        'Please check your internet connection.',
      );
    }
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
      if (message['recommendations'] != 'null') {
        _chatMessages.add(Message(
            text: message['text'],
            byMe: message['byMe'],
            time: message['time'],
            recommendations: message['recommendations']));
      } else {
        _chatMessages.add(Message(
            text: message['text'],
            byMe: message['byMe'],
            time: message['time']));
      }
    });
  }

  void showError(String title, String message) {
    Get.rawSnackbar(
      titleText: title ??
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
      messageText: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red[700],
    );
  }
}

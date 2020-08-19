import 'dart:convert' as convert;
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:googleapis/dialogflow/v2.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';

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
  double _rating;
  File pickedImage;
  List<Message> _chatMessages = [];
  List<Map<String, String>> categories = [];
  bool isSigning = false;
  bool isLoaded = false;
  int _replying = 0;
  DialogflowApi _dialog;

  void setData({
    String email,
    String userName,
    String imageUrl,
    String userId,
    File pickedImage,
    List<Map<String, String>> categories,
    double rating,
  }) {
    this.email = email;
    this.userName = userName;
    this.imageUrl = imageUrl;
    this.userId = userId;
    this.pickedImage = pickedImage;
    this.categories = categories;
    this._rating = rating;
  }

  Future<List<Map<String, String>>> loadData() async {
    if (isLoaded) {
      isLoaded = false;
      notifyListeners();
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
      rating: userData.data.containsKey('rating') ? userData['rating'] : 0.0,
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

  Future<bool> signUp(String email, String userName, String password,
      File pickedImage, List<Map<String, String>> categories) async {
    bool timedOut = false;
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .timeout(Duration(seconds: 10), onTimeout: () {
      timedOut = true;
      return;
    });
    if (timedOut) return true;
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
    String url = 'default';
    if (pickedImage != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(user.uid + '.jpg');
      await ref.putFile(pickedImage).onComplete;
      url = await ref.getDownloadURL();
    }
    await Firestore.instance.collection('users').document(user.uid).setData({
      'userName': userName,
      'email': email,
      'imageUrl': url,
      'rating': 0.0,
    });
    setData(
      email: email,
      userName: userName,
      imageUrl: url,
      userId: user.uid,
      categories: categories,
      rating: 0.0,
    );
    isLoaded = true;
    _chatMessages.clear();
    _chatMessages = [];
    notifyListeners();
    return false;
  }

  List<Message> get messages {
    return [..._chatMessages];
  }

  double get rating {
    return _rating;
  }

  Map<String, dynamic> toMap(rec) {
    return {
      'Title': rec['Title'],
      'Poster': rec['Poster'],
      'imdbRating': rec['imdbRating'],
      'imdbID': rec['imdbID'],
      'Director': rec['Director'],
      'Writer': rec['Writer'],
      'Actors': rec['Actors'],
      'Plot': rec['Plot'],
      'Released': rec['Released'],
      'Runtime': rec['Runtime'],
    };
  }

  Future<GoogleCloudDialogflowV2QueryResult> _requestChatBot(
      String text) async {
    var dialogSessionId = "projects/newagent-xkyv/agent/sessions/1234";

    Map data = {
      "queryInput": {
        "text": {
          "text": text,
          "languageCode": "en",
        }
      }
    };

    var request = GoogleCloudDialogflowV2DetectIntentRequest.fromJson(data);

    var resp = await _dialog.projects.agent.sessions
        .detectIntent(request, dialogSessionId);
    var result = resp.queryResult;
    return result;
  }

  Future<void> _initChatbot() async {
    String configString =
        await rootBundle.loadString('assets/newagent-xkyv-abe80b73a056.json');
    String _dialogFlowConfig = configString;

    var credentials = new ServiceAccountCredentials.fromJson(_dialogFlowConfig);

    const _SCOPES = const [DialogflowApi.CloudPlatformScope];

    var httpClient = await clientViaServiceAccount(credentials, _SCOPES);
    _dialog = new DialogflowApi(httpClient);
  }

  Future<void> addMessage(Message message) async {
    if (_replying > 0) {
      _chatMessages.insert(1, message);
    } else {
      _chatMessages.insert(0, message);
    }
    notifyListeners();
    try {
      if (message.byMe) {
        _replying++;
        if (_dialog == null) {
          await _initChatbot();
        }
        await Future.wait([
          Firestore.instance
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
          }),
          letDarvisReply(message.text)
        ]);
      } else {
        _replying--;
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
      }
    } on PlatformException {
      if (_replying > 0) {
        _chatMessages.removeAt(0);
        _replying = 0;
      }
      _chatMessages.removeAt(0);
      notifyListeners();
      addMessage(
        Message(
          text:
              'I can\'t talk now check the internet connection or try again later.',
          byMe: false,
          time: DateTime.now().toIso8601String(),
        ),
      );
    } on NoSuchMethodError catch (error) {
      print(error.toString());
    } catch (error) {
      if (_replying > 0) {
        _chatMessages.removeAt(0);
        _replying = 0;
      }
      _chatMessages.removeAt(0);
      notifyListeners();
      showError('Could\'t send your message', error);
    }
  }

  Future<dynamic> getFilmByID(String id) async {
    String url = "http://www.omdbapi.com/?i=$id&apikey=eb4d3f87&plot=full";
    final response = await http.get(url);
    return convert.jsonDecode(response.body);
  }

  Future<void> letDarvisReply(String text) async {
    try {
      if (_replying == 1) {
        _chatMessages.insert(
          0,
          Message(
            text: '..sudo..replying..',
            byMe: false,
            time: DateTime.now().toIso8601String(),
          ),
        );
        notifyListeners();
      }
      String url = 'http://3.230.233.147/darvis';
      final dialogFlowResult = await _requestChatBot(text);
      final intent = dialogFlowResult.intent.displayName;
      final response = await http.post(url,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: convert.jsonEncode({
            'Message': text,
            'Intent': intent == 'request' ? 'C' : 'N',
            'NumberFilms': 50
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
          responseData['FilmsIDs'].shuffle();
          for (int i = 0; i < min(responseData['FilmsIDs'].length, 5); i++) {
            recs.add(await getFilmByID(responseData['FilmsIDs'][i]));
          }
          addMessage(
            (recs.length > 0)
                ? Message(
                    text: responseData['Response'],
                    byMe: false,
                    time: DateTime.now().toIso8601String(),
                    recommendations: recs,
                  )
                : Message(
                    text: responseData['Response'],
                    byMe: false,
                    time: DateTime.now().toIso8601String(),
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
    } on PlatformException {
      addMessage(
        Message(
          text:
              'I can\'t talk now check the internet connection or try again later.',
          byMe: false,
          time: DateTime.now().toIso8601String(),
        ),
      );
    } catch (error) {
      addMessage(
        Message(
          text:
              'I can\'t talk now check the internet connection or try again later.',
          byMe: false,
          time: DateTime.now().toIso8601String(),
        ),
      );
      debugPrint("reply: $error");
    }
    if (_replying == 0) {
      _chatMessages.removeAt(0);
      notifyListeners();
    }
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
    String currentEmail = this.email;
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
      this.email = currentEmail;
      notifyListeners();
      showError(
        'Couldn\'t change your email',
        error.message == 'ERROR_EMAIL_ALREADY_IN_USE'
            ? 'This email already exists'
            : 'Couldn\'t change email as you entered a wrong current password.',
      );
    } catch (error) {
      this.email = currentEmail;
      notifyListeners();
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
    var tmpList = _chatMessages;
    try {
      _chatMessages.clear();
      notifyListeners();
      final msgs = await Firestore.instance
          .collection('users')
          .document(userId)
          .collection('chats')
          .getDocuments();
      await Future.forEach(msgs.documents, (doc) async {
        Firestore.instance
            .collection('users')
            .document(userId)
            .collection('chats')
            .document(doc.documentID)
            .delete();
      });
    } on PlatformException {
      _chatMessages = tmpList;
      notifyListeners();
      showError(
        'Couldn\'t change your image',
        'Please check your internet connection.',
      );
    } catch (error) {
      _chatMessages = tmpList;
      notifyListeners();
      showError(
        'Couldn\'t change your image',
        'Please check your internet connection.',
      );
    }
  }

  Future<void> sendFeedback(String text, double rating) async {
    double prevRating = _rating;
    try {
      _rating = rating;
      notifyListeners();
      await Future.wait(
        [
          Firestore.instance.collection('feedback').add({
            'userId': userId,
            'rating': rating,
            'feedback': text.trim(),
            'date': DateTime.now().toIso8601String(),
          }),
          Firestore.instance.collection('users').document(userId).setData(
            {'rating': rating},
            merge: true,
          ),
        ],
      );
    } on PlatformException {
      _rating = prevRating;
      notifyListeners();
      showError(
        'Couldn\'t send your feedback',
        'Please check your internet connection.',
      );
    } catch (error) {
      _rating = prevRating;
      notifyListeners();
      showError(
        'Couldn\'t send your feedback',
        'Please check your internet connection.',
      );
    }
  }

  Future<bool> loadMessage() async {
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
    return true;
  }

  void showError(String title, String message) {
    Get.rawSnackbar(
      titleText: title != null
          ? Text(
              title,
              style: TextStyle(color: Colors.white),
            )
          : null,
      messageText: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red[700],
    );
  }
}

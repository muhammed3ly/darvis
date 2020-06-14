import 'dart:io';

import 'package:darvis/widgets/chat_screen_widgets/char_screen_header.dart';
import 'package:darvis/widgets/chat_screen_widgets/message_bubble.dart';
import 'package:darvis/widgets/chat_screen_widgets/typing_bar.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  double screenHeight;
  bool first = true;
  String _message, _last;
  File _file;
  List<Map<String, String>> _messages = [
    {
      'who': 'Bot',
      'message': 'I\'m a chatbot',
    }
  ];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
  }

  void _sendMessage(String message, {File file}) {
    _message = message;
    if (file != null) {
      _file = file;
    }
    setState(() {
      _messages.add({
        'who': 'User',
        'message': message,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Color.fromRGBO(3, 155, 229, 1),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ChatScreenHeader(screenHeight * 0.15),
                  Container(
                    height: screenHeight * 0.85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8).add(EdgeInsets.only(top: 8)),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 8.0, right: 8.0),
                              child: ListView.builder(
                                itemCount: _messages.length,
                                itemBuilder: (ctx, i) {
                                  String turn = 'middle';
                                  if (_last == null ||
                                      _last != _messages[i]['who']) {
                                    turn = 'start';
                                  } else if (i == _messages.length - 1 ||
                                      _messages[i]['who'] !=
                                          _messages[i + 1]['who']) {
                                    turn = 'last';
                                  }
                                  _last = _messages[i]['who'];
                                  return ChatBubble(
                                    ValueKey(DateTime.now()),
                                    _messages[i]['who'],
                                    _messages[i]['message'],
                                    turn,
                                  );
                                },
                              ),
                            ),
                          ),
                          TypingBar(_sendMessage),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

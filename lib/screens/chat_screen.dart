import 'dart:io';

import 'package:chat_bot/providers/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/chat_screen_widgets/char_screen_header.dart';
import '../widgets/chat_screen_widgets/message_bubble.dart';
import '../widgets/chat_screen_widgets/typing_bar.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat';
  final Function toggle;
  ChatScreen(this.toggle);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  double screenHeight;
  bool first = true;
  bool _last;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
  }

  Future<void> _sendMessage(String message, {File file}) async {
    try {
      await Provider.of<User>(context, listen: false).addMessage(
        Message(
          text: message,
          byMe: true,
          time: DateTime.now().toIso8601String(),
        ),
      );
    } catch (error) {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Message could not be sent.'),
            content: Text(
                'We couldn\'t send your message right now, try again later.'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            //color: Color.fromRGBO(3, 155, 229, 1),
            decoration: BoxDecoration(
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
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ChatScreenHeader(screenHeight * 0.15, widget.toggle),
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
                              child: Consumer<User>(
                                builder: (_, user, __) => ListView.builder(
                                  itemCount: user.messages.length,
                                  itemBuilder: (ctx, i) {
                                    String turn = 'middle';
                                    if (_last == null ||
                                        _last != user.messages[i].byMe) {
                                      turn = 'start';
                                    } else if (i == user.messages.length - 1 ||
                                        user.messages[i].byMe !=
                                            user.messages[i + 1].byMe) {
                                      turn = 'last';
                                    }
                                    _last = user.messages[i].byMe;
                                    return ChatBubble(
                                      ValueKey(user.messages[i].time),
                                      user.messages[i].byMe,
                                      user.messages[i].text,
                                      turn,
                                    );
                                  },
                                ),
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

import 'dart:math';

import 'package:chat_bot/providers/users.dart';
import 'package:chat_bot/widgets/chat_screen_widgets/chat_bubble.dart';
import 'package:chat_bot/widgets/chat_screen_widgets/typing_bar.dart';
import 'package:chat_bot/widgets/global_widgets/custom_appbar.dart';
import 'package:chat_bot/widgets/global_widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey;
  ScrollController _listController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(243, 240, 248, 1),
      drawer: CustomDrawer(),
      appBar: CustomAppbar(title: 'Chat Room', openDrawer: drawer),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.09,
                  vertical: 10,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20).add(
                  const EdgeInsets.only(
                    right: 25,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/Asset 05.png',
                      height: 35,
                    ),
                    Expanded(
                      child: Text(
                        'Darvis',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20 * MediaQuery.of(context).textScaleFactor,
                          color: Color.fromRGBO(53, 77, 175, 1),
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.09,
                ).add(
                  const EdgeInsets.only(
                    bottom: 10,
                  ),
                ),
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: _resetChat,
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Reset Chat',
                                style: TextStyle(
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(53, 77, 175, 1),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(pi),
                                child: Icon(
                                  Icons.refresh,
                                  size: 20 *
                                      MediaQuery.of(context).textScaleFactor,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Save Conversation',
                              style: TextStyle(
                                letterSpacing: 1,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(53, 77, 175, 1),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.save,
                              size: 20 * MediaQuery.of(context).textScaleFactor,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.07,
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            ListView.builder(
                              controller: _listController,
                              physics: BouncingScrollPhysics(),
                              itemCount:
                                  Provider.of<User>(context).messages.length,
                              reverse: true,
                              padding: const EdgeInsets.only(bottom: 15),
                              itemBuilder: (_, i) {
                                String turn = 'middle';
                                if (i ==
                                        Provider.of<User>(context)
                                                .messages
                                                .length -
                                            1 ||
                                    (i <
                                            Provider.of<User>(context)
                                                    .messages
                                                    .length -
                                                1 &&
                                        Provider.of<User>(context)
                                                .messages[i + 1]
                                                .byMe !=
                                            Provider.of<User>(context)
                                                .messages[i]
                                                .byMe)) {
                                  turn = 'start';
                                }
                                if (Provider.of<User>(context)
                                        .messages[i]
                                        .recommendations !=
                                    null) {
                                  return ChatBubble.chatbotRecommendation(
                                    ValueKey(Provider.of<User>(context)
                                        .messages[i]
                                        .time),
                                    {
                                      'message': Provider.of<User>(context)
                                          .messages[i]
                                          .text,
                                      'list': Provider.of<User>(context)
                                          .messages[i]
                                          .recommendations
                                    },
                                    newMessage: turn == 'start',
                                  );
                                } else if (Provider.of<User>(context)
                                    .messages[i]
                                    .byMe) {
                                  return ChatBubble.user(
                                    ValueKey(Provider.of<User>(context)
                                        .messages[i]
                                        .time),
                                    Provider.of<User>(context).messages[i].text,
                                    newMessage: turn == 'start',
                                  );
                                } else if (Provider.of<User>(context)
                                        .messages[i]
                                        .text ==
                                    '..sudo..replying..') {
                                  return ChatBubble.typing(
                                    ValueKey('typing'),
                                    newMessage: Provider.of<User>(context)
                                        .messages[i + 1]
                                        .byMe,
                                  );
                                } else {
                                  return ChatBubble.chatbot(
                                    ValueKey(Provider.of<User>(context)
                                        .messages[i]
                                        .time),
                                    Provider.of<User>(context).messages[i].text,
                                    newMessage: turn == 'start',
                                  );
                                }
                              },
                            ),
                            if (_listController.offset > 20)
                              Positioned(
                                right: 0,
                                bottom: 15,
                                child: GestureDetector(
                                  onTap: () {
                                    _listController.animateTo(
                                      0,
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.bounceInOut,
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[200],
                                    ),
                                    child: Icon(
                                      FontAwesomeIcons.angleDoubleDown,
                                      size: 18 *
                                          MediaQuery.of(context)
                                              .textScaleFactor,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      TypingBar(_sendMessage),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void drawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  @override
  void initState() {
    _listController = ScrollController(initialScrollOffset: 0);
    super.initState();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void _sendMessage(String message) async {
    await Provider.of<User>(context, listen: false).addMessage(
      Message(
        text: message,
        byMe: true,
        time: DateTime.now().toIso8601String(),
      ),
    );
  }

  void _resetChat() async {
    final respone = await showDialog(
      barrierDismissible: false,
      context: context,
      child: SimpleDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Text('Are you sure you want to clear the chat?'),
        children: <Widget>[
          SimpleDialogOption(
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Yes',
                  style: TextStyle(color: Colors.green),
                )
              ],
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          SimpleDialogOption(
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'No',
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
    if (respone) {
      await Provider.of<User>(context, listen: false).resetChat();
    }
  }
}

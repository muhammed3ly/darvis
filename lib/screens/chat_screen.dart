import 'package:audioplayers/audio_cache.dart';
import 'package:chat_bot/providers/users.dart';
import 'package:chat_bot/widgets/chat_screen_widgets/recommendations_bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/chat_screen_widgets/chat_screen_header.dart';
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
  bool first;
  bool _last;
  bool _replying;
  @override
  void initState() {
    super.initState();
    first = true;
    _replying = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
  }

  Future<void> _sendMessage(String message) async {
    // AudioCache cache = AudioCache();
    // var sound;
    try {
      setState(() {
        _replying = true;
      });
      // sound = await cache.loop("soundEffects/typing.mp3");
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
            content: Text(error.message),
            //'We couldn\'t send your message right now, try again later.'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ));
    }
    // await sound.stop();
    // cache.clearCache();
    setState(() {
      _replying = false;
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
                      padding:
                          EdgeInsets.all(8), //.add(EdgeInsets.only(top: 8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 8.0, right: 8.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                reverse: true,
                                itemCount:
                                    Provider.of<User>(context).messages.length,
                                itemBuilder: (ctx, i) {
                                  String turn = 'middle';
                                  if (i == 0 ||
                                      _last !=
                                          Provider.of<User>(context)
                                              .messages[i]
                                              .byMe) {
                                    turn = 'start';
                                  }
                                  _last = Provider.of<User>(context)
                                      .messages[i]
                                      .byMe;
                                  if (Provider.of<User>(context)
                                          .messages[i]
                                          .recommendations !=
                                      null) {
                                    return RecommendationsBubble(
                                        Provider.of<User>(context)
                                            .messages[i]
                                            .text,
                                        Provider.of<User>(context)
                                            .messages[i]
                                            .recommendations);
                                  }
                                  return ChatBubble(
                                    Provider.of<User>(context).messages[i].byMe,
                                    Provider.of<User>(context).messages[i].text,
                                    turn,
                                  );
                                },
                              ),
                            ),
                          ),
                          if (_replying)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: ChatBubble(
                                false,
                                '',
                                'start',
                                replying: true,
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

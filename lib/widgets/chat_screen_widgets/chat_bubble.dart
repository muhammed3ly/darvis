import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:chat_bot/screens/movie_details_screen.dart';

enum MessageType {
  Normal,
  List,
  Typing,
}

enum Sender {
  User,
  Chatbot,
}

class ChatBubble extends StatefulWidget {
  final Sender _sender;
  final MessageType _messageType;
  final bool newMessage;
  final dynamic message;
  ChatBubble.chatbot(key, this.message, {this.newMessage = true})
      : _sender = Sender.Chatbot,
        _messageType = MessageType.Normal,
        super(key: key);

  ChatBubble.chatbotRecommendation(key, this.message, {this.newMessage = true})
      : _sender = Sender.Chatbot,
        _messageType = MessageType.List,
        super(key: key);

  ChatBubble.user(key, this.message, {this.newMessage = true})
      : _sender = Sender.User,
        _messageType = MessageType.Normal,
        super(key: key);

  ChatBubble.typing(key, {this.message = 'Typing...', this.newMessage = true})
      : _sender = Sender.Chatbot,
        _messageType = MessageType.Typing,
        super(key: key);
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  Color _backGroundColor;
  AudioCache _cache;
  var _sound;
  bool _firstRun;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: widget._sender == Sender.Chatbot
          ? WrapAlignment.start
          : WrapAlignment.end,
      children: <Widget>[
        Container(
          color: _backGroundColor,
          margin: widget.newMessage
              ? const EdgeInsets.only(top: 15)
              : const EdgeInsets.only(top: 5),
          constraints: widget._messageType != MessageType.Typing
              ? BoxConstraints(
                  minWidth: 50 * MediaQuery.of(context).textScaleFactor,
                )
              : BoxConstraints(
                  maxWidth: 80 * MediaQuery.of(context).textScaleFactor),
          child: widget._messageType == MessageType.Normal
              ? _normalMessageBuilder()
              : widget._messageType == MessageType.Typing
                  ? _typing()
                  : _listMessageBuilder(),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _backGroundColor = widget._sender == Sender.Chatbot
        ? Color.fromRGBO(160, 210, 254, 1)
        : Color.fromRGBO(219, 238, 255, 1);
    _firstRun = true;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_firstRun) {
      _firstRun = false;
      if (widget._messageType == MessageType.Typing) {
        _cache = AudioCache();
        _sound = await _cache.loop("soundEffects/typing.mp3");
      }
    }
  }

  @override
  void dispose() async {
    super.dispose();
    if (widget._messageType == MessageType.Typing) {
      await _sound.stop();
      _cache.clearCache();
    }
  }

  Widget _listMessageBuilder() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8, top: 5),
            child: Text(
              widget.message['message'],
              softWrap: true,
              style: TextStyle(
                color: Color.fromRGBO(53, 77, 175, 1),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: widget.message['list'].length,
              itemBuilder: (_, i) {
                String heroTag = widget.message['list'][i]['imdbID'] +
                    DateTime.now().toIso8601String();
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MovieDetailsScreen(
                          widget.message['list'][i],
                          widget.message['list'],
                          heroTag,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5).add(
                      EdgeInsets.only(
                        left: i == 0 ? 10 : 0,
                        right: i == widget.message['list'].length - 1 ? 10 : 0,
                      ),
                    ),
                    constraints: BoxConstraints(maxWidth: 150),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                          child: Hero(
                            tag: heroTag,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: FadeInImage(
                                  fit: BoxFit.cover,
                                  placeholder: AssetImage(
                                      'assets/images/movie_placeholder.png'),
                                  image: NetworkImage(
                                    widget.message['list'][i]['Poster'],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              widget.message['list'][i]['Title'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _normalMessageBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Text(
        widget.message,
        softWrap: true,
        style: TextStyle(
          color: Color.fromRGBO(53, 77, 175, 1),
        ),
      ),
    );
  }

  Widget _typing() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: SpinKitThreeBounce(
        color: Color.fromRGBO(53, 77, 175, 1),
        size: 18 * MediaQuery.of(context).textScaleFactor,
      ),
    );
  }
}

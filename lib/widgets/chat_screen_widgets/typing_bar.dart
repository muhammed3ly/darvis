import 'dart:math';

import 'package:flutter/material.dart';

class TypingBar extends StatefulWidget {
  final Function _sendMessage;
  TypingBar(this._sendMessage);
  @override
  _TypingBarState createState() => _TypingBarState();
}

class _TypingBarState extends State<TypingBar> {
  bool _canSend;
  TextEditingController _messageController;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.01,
      ).add(
        const EdgeInsets.only(
          bottom: 15,
        ),
      ),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              onChanged: (value) {
                setState(() {
                  if (value.trim().isNotEmpty) {
                    _canSend = true;
                  } else {
                    _canSend = false;
                  }
                });
              },
              style: TextStyle(
                color: Color.fromRGBO(53, 77, 175, 1),
                fontWeight: FontWeight.w500,
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 5,
              minLines: 1,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: 'Type a message',
                hintStyle: TextStyle(color: Colors.grey[400]),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: InkWell(
              onTap: _canSend ? _trySendingMessage : null,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationZ(-0.25 * pi),
                child: Icon(
                  Icons.send,
                  color: _canSend
                      ? Color.fromRGBO(53, 77, 175, 1)
                      : Color.fromRGBO(53, 77, 175, 1).withOpacity(0.6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _canSend = false;
  }

  void _trySendingMessage() {
    widget._sendMessage(_messageController.text.trim());
    if (mounted) {
      setState(() {
        _messageController.clear();
        _canSend = false;
      });
      FocusScope.of(context).unfocus();
    }
  }
}

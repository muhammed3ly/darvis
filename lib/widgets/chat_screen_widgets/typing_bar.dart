import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class TypingBar extends StatefulWidget {
  final Function _sendMessage;
  TypingBar(this._sendMessage);
  @override
  _TypingBarState createState() => _TypingBarState();
}

class _TypingBarState extends State<TypingBar> {
  File _file;
  String _message = '';
  TextEditingController _messageController = TextEditingController();
  final outlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50)),
    borderSide: BorderSide(
      width: 0,
      color: Color.fromRGBO(227, 243, 251, 1),
    ),
  );
  FocusNode textFieldFocusNode = FocusNode();
  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _messageController,
        onChanged: (value) {
          setState(() {
            _message = value;
          });
        },
        focusNode: textFieldFocusNode,
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        minLines: 1,
        decoration: InputDecoration(
          prefixIcon: InkWell(
            onTap: () {
              print('add attachment');
            },
            child: Transform.rotate(
              angle: -45 * pi / 180,
              child: Icon(
                Icons.attachment,
                color: Colors.black26,
              ),
            ),
          ),
          hintText: 'Type a message...',
          filled: true,
          fillColor: Color.fromRGBO(227, 243, 251, 1),
          focusedBorder: outlineBorder,
          disabledBorder: outlineBorder,
          enabledBorder: outlineBorder,
          border: outlineBorder,
          errorBorder: outlineBorder,
          focusedErrorBorder: outlineBorder,
          suffixIcon: InkWell(
            onTap: _message.isNotEmpty
                ? () {
                    Future.delayed(Duration(milliseconds: 50), () {
                      _messageController.clear();
                      if (_file != null) {
                        widget._sendMessage(_message, file: _file);
                      } else {
                        widget._sendMessage(_message);
                      }
                      _messageController.clear();
                      setState(() {
                        _file = null;
                        _message = '';
                      });
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: _message.isNotEmpty
                    ? Color.fromRGBO(3, 155, 229, 1)
                    : Color.fromRGBO(141, 209, 243, 1),
                child: Center(
                  child: Container(
                    transform: _message.isNotEmpty
                        ? (Matrix4.rotationZ(-45 * pi / 180)
                          ..translate(-17.0, 9))
                        : null,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

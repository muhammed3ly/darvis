import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String _sender, _message, _turn;
  ChatBubble(Key key, this._sender, this._message, this._turn)
      : super(key: key);
  double _space = 2.0;
  @override
  Widget build(BuildContext context) {
    if (_turn == 'start') {
      _space = 7;
    }
    return Row(
      mainAxisAlignment:
          _sender == 'User' ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(top: _space),
          constraints: BoxConstraints(minWidth: 70, maxWidth: 300),
          decoration: BoxDecoration(
            color: _sender != 'User'
                ? Color.fromRGBO(179, 223, 246, 1)
                : Color.fromRGBO(229, 244, 251, 1),
            borderRadius: BorderRadius.only(
              topLeft: (_turn == 'start')
                  ? Radius.circular(12)
                  : (_sender == 'Bot')
                      ? Radius.circular(5)
                      : Radius.circular(12),
              topRight: (_turn == 'start')
                  ? Radius.circular(12)
                  : (_sender == 'User')
                      ? Radius.circular(5)
                      : Radius.circular(12),
              bottomLeft: _sender != 'Bot'
                  ? Radius.circular(12)
                  : (_turn == 'last')
                      ? Radius.circular(12)
                      : Radius.circular(5),
              bottomRight: _sender != 'User'
                  ? Radius.circular(12)
                  : (_turn == 'last')
                      ? Radius.circular(12)
                      : Radius.circular(5),
            ),
          ),
          child: Text(
            _message,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}

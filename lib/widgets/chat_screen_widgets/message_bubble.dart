import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatBubble extends StatelessWidget {
  final String _message, _turn;
  String _sender;
  final bool _byMe, replying;
  ChatBubble(this._byMe, this._message, this._turn, {this.replying = false}) {
    if (_byMe) {
      _sender = 'User';
    } else {
      _sender = 'Bot';
    }
  }
  @override
  Widget build(BuildContext context) {
    double _space = 2.0;
    if (_turn == 'start') {
      _space = 7;
    }
    return Row(
      mainAxisAlignment:
          _sender == 'User' ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: _space),
          constraints:
              BoxConstraints(minWidth: 70, maxWidth: replying ? 70 : 300),
          decoration: BoxDecoration(
            color: _sender != 'User'
                ? Color.fromRGBO(179, 223, 246, 1)
                : Color.fromRGBO(229, 244, 251, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
          ),
          child: replying
              ? SpinKitThreeBounce(
                  color: Colors.black,
                  size: 18,
                )
              : Text(
                  _message,
                  style: TextStyle(
                      fontSize: 15 * MediaQuery.of(context).textScaleFactor),
                  softWrap: true,
                ),
        ),
      ],
    );
  }
}

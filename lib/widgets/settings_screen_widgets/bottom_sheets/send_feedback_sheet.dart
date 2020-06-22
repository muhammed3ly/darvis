import 'dart:math';

import 'package:flutter/material.dart';

class SendFeedbackSheet extends StatelessWidget {
  final Function send;
  SendFeedbackSheet(this.send);
  final outlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50)),
    borderSide: BorderSide(
      width: 0,
      color: Colors.white,
    ),
  );
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).viewInsets.bottom + 100,
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          top: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
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
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromRGBO(227, 243, 251, 1),
                  focusedBorder: outlineBorder,
                  disabledBorder: outlineBorder,
                  enabledBorder: outlineBorder,
                  border: outlineBorder,
                  errorBorder: outlineBorder,
                  focusedErrorBorder: outlineBorder,
                ),
              ),
            ),
            FlatButton.icon(
              icon: Icon(
                Icons.send,
                color: Colors.white,
              ),
              label: Text('Send'),
              textColor: Colors.white,
              onPressed: () => send(_controller.text),
            ),
          ],
        ),
      ),
    );
  }
}

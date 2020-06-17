import 'package:flutter/material.dart';

class NameBottomSheet extends StatelessWidget {
  final Function _changeName;
  final String _userName;
  final bool isUser;
  NameBottomSheet(this._changeName, this._userName, this.isUser) {
    _controller.text = _userName;
  }
  final outlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50)),
    borderSide: BorderSide(
      width: 0,
      color: Colors.white,
    ),
  );
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
                Icons.save,
                color: Colors.white,
              ),
              label: Text('Save'),
              textColor: Colors.white,
              onPressed: () => _changeName(_controller.text, isUser),
            ),
          ],
        ),
      ),
    );
  }
}

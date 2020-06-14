import 'package:flutter/material.dart';

class NameBottomSheet extends StatelessWidget {
  final Function _changeName;
  final String _userName;
  NameBottomSheet(this._changeName, this._userName) {
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
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(3, 155, 229, 1),
              Colors.black87,
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
              onPressed: () => _changeName(_controller.text),
            ),
          ],
        ),
      ),
    );
  }
}

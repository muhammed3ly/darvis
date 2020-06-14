import 'package:flutter/material.dart';

class ChangePassword extends StatelessWidget {
  String _password = '';
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  final Function _changePassword;
  ChangePassword(this._changePassword);
  void _tryChanging() {
    if (_form.currentState.validate()) {
      _changePassword(_password);
    }
  }

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
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Password',
                ),
                obscureText: true,
                onChanged: (value) {
                  _password = value;
                },
                validator: (value) {
                  if (value.isEmpty || value.length < 6) {
                    return 'Password must consists of at least 6 characters.';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty || value != _password) {
                    return 'Passwords do not match.';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              FlatButton.icon(
                icon: Icon(Icons.save),
                label: Text('Change Password'),
                textColor: Colors.white,
                //color: Colors.white,
                onPressed: _tryChanging,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

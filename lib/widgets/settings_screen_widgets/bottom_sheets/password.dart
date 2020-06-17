import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  final Function _changePassword;
  ChangePassword(this._changePassword);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String _password = '';

  GlobalKey<FormState> _form = GlobalKey<FormState>();

  FocusNode _confirmPassword = FocusNode();
  bool _showPassword, _showConfirmPassword;

  @override
  void initState() {
    super.initState();
    _showPassword = false;
    _showConfirmPassword = false;
  }

  @override
  void dispose() {
    super.dispose();
    _confirmPassword.dispose();
  }

  void _tryChanging() {
    if (_form.currentState.validate()) {
      widget._changePassword(_password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom,
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
      child: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Color.fromRGBO(20, 74, 100, 1),
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      }),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Password',
                  errorStyle: TextStyle(color: Colors.yellow),
                ),
                obscureText: _showPassword,
                onChanged: (value) {
                  _password = value;
                },
                onFieldSubmitted: (_) {
                  _confirmPassword.requestFocus();
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
                focusNode: _confirmPassword,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      icon: Icon(
                        _showConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Color.fromRGBO(20, 74, 100, 1),
                      ),
                      onPressed: () {
                        setState(() {
                          _showConfirmPassword = !_showConfirmPassword;
                        });
                      }),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Confirm Password',
                  errorStyle: TextStyle(
                    color: Colors.yellow,
                  ),
                ),
                obscureText: _showConfirmPassword,
                onFieldSubmitted: (_) => _tryChanging(),
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
              Container(
                margin: const EdgeInsets.only(right: 8, bottom: 10),
                child: FlatButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  icon: Icon(Icons.save),
                  label: Text('Change Password'),
                  textColor: Color.fromRGBO(20, 74, 100, 1),
                  color: Colors.white,
                  onPressed: _tryChanging,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

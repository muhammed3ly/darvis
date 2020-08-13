import 'package:chat_bot/widgets/profile_screen_widgets/edit_password_tfs.dart';
import 'package:flutter/material.dart';

class EditPassword extends StatefulWidget {
  final Function editPassword;
  EditPassword(this.editPassword);
  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword>
    with TickerProviderStateMixin {
  AnimationController newController, confirmController, buttonController;
  TextEditingController _oldTEC, _newTEC, _confirmTEC;
  bool _firstRun, _close;
  GlobalKey<ScaffoldState> _scaffold;
  FocusNode _newPassword, _confirmPasswod;
  @override
  void initState() {
    super.initState();
    _firstRun = true;
    _scaffold = GlobalKey<ScaffoldState>();
    _oldTEC = TextEditingController();

    _newTEC = TextEditingController();
    _confirmTEC = TextEditingController();
    newController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    confirmController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    buttonController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _close = false;
    _newPassword = FocusNode();
    _confirmPasswod = FocusNode();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_firstRun) {
      setState(() {
        _firstRun = false;
      });
      await Future.delayed(Duration(milliseconds: 150));
      newController.forward();
      confirmController.forward();
      buttonController.forward();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _newPassword.dispose();
    _confirmPasswod.dispose();
    _oldTEC.dispose();
    _newTEC.dispose();
    _confirmTEC.dispose();
    newController.dispose();
    confirmController.dispose();
    buttonController.dispose();
  }

  void showError(String msg) {
    _scaffold.currentState.showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red[700],
      ),
    );
  }

  void closeScreen() async {
    _scaffold.currentState.removeCurrentSnackBar();
    setState(() {
      _close = true;
    });
    await Future.wait(
      [
        newController.reverse(),
        confirmController.reverse(),
        buttonController.reverse(),
      ],
    );
    Navigator.of(context).pop();
  }

  void validateThenEdit() {
    String oldText = _oldTEC.text,
        newText = _newTEC.text,
        confirmText = _confirmTEC.text;
    if (oldText.trimRight().isEmpty ||
        newText.trimRight().isEmpty ||
        confirmText.trimRight().isEmpty) {
      showError('Please fill the three fields.');
    } else if (newText.trimRight() != confirmText.trimRight()) {
      showError('Confirmation of new password failed.');
    } else if (newText.length < 6) {
      showError('Please enter at least 6 characters password.');
    } else {
      widget.editPassword(oldText, newText);
      closeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _scaffold.currentState.removeCurrentSnackBar();
        setState(() {
          _close = true;
        });
        await Future.wait(
          [
            newController.reverse(),
            confirmController.reverse(),
            buttonController.reverse(),
          ],
        );
        return true;
      },
      child: Scaffold(
        key: _scaffold,
        backgroundColor: Colors.black87,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: closeScreen,
                  child: Container(
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).viewPadding.top,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Positioned(
                  left: 15,
                  top: 15,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: _close ? 0.0 : 1.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: closeScreen,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: 'Password',
                        child: Material(
                          color: Colors.transparent,
                          child: EditPasswordTFs(
                            title: 'Current Password',
                            controller: _oldTEC,
                            onSubmitted: (_) {
                              _newPassword.requestFocus();
                            },
                          ),
                        ),
                      ),
                      SizeTransition(
                        sizeFactor: CurvedAnimation(
                          curve: Curves.fastOutSlowIn,
                          parent: newController,
                        ),
                        child: EditPasswordTFs(
                          title: 'New Password',
                          myFocusNode: _newPassword,
                          controller: _newTEC,
                          onSubmitted: (_) {
                            _confirmPasswod.requestFocus();
                          },
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: _close ? 0 : 1,
                        duration: Duration(milliseconds: 290),
                        child: SizeTransition(
                          sizeFactor: CurvedAnimation(
                            curve: Curves.fastOutSlowIn,
                            parent: confirmController,
                          ),
                          child: EditPasswordTFs(
                            title: 'Confirm Password',
                            controller: _confirmTEC,
                            myFocusNode: _confirmPasswod,
                            onSubmitted: (_) => validateThenEdit(),
                          ),
                        ),
                      ),
                      SizeTransition(
                        sizeFactor: CurvedAnimation(
                          curve: Curves.fastOutSlowIn,
                          parent: buttonController,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: FlatButton(
                            shape: StadiumBorder(),
                            color: Color.fromRGBO(53, 77, 175, 1),
                            child: Text(
                              'Edit Password',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: validateThenEdit,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

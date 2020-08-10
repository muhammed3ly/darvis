import 'package:chat_bot/widgets/profile_screen_widgets/edit_password_tfs.dart';
import 'package:flutter/material.dart';

class EditEmail extends StatefulWidget {
  final Function editEmail;
  EditEmail(this.editEmail);
  @override
  _EditEmailState createState() => _EditEmailState();
}

class _EditEmailState extends State<EditEmail> with TickerProviderStateMixin {
  AnimationController passwordController, buttonController;
  TextEditingController _emailTEC, _passwordTEC;
  bool _firstRun;
  GlobalKey<ScaffoldState> _scaffold;
  FocusNode _password;
  @override
  void initState() {
    super.initState();
    _firstRun = true;
    _scaffold = GlobalKey<ScaffoldState>();
    _emailTEC = TextEditingController();

    _passwordTEC = TextEditingController();
    passwordController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    buttonController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _password = FocusNode();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_firstRun) {
      setState(() {
        _firstRun = false;
      });
      await Future.delayed(Duration(milliseconds: 150));
      passwordController.forward();
      buttonController.forward();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailTEC.dispose();
    _passwordTEC.dispose();
    passwordController.dispose();
    buttonController.dispose();
    _password.dispose();
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
    await Future.wait(
      [
        buttonController.reverse(),
        passwordController.reverse(),
      ],
    );
    Navigator.of(context).pop();
  }

  void validateThenEdit() {
    String password = _passwordTEC.text, email = _emailTEC.text;
    if (password.trimRight().isEmpty || email.trimRight().isEmpty) {
      showError('Please fill the two fields.');
    } else if (!email.contains('@')) {
      showError('Please enter valid email.');
    } else {
      print('object');
      widget.editEmail(email, password);
      closeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _scaffold.currentState.removeCurrentSnackBar();
        await Future.wait(
          [
            buttonController.reverse(),
            passwordController.reverse(),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      tag: 'Email',
                      child: Material(
                        color: Colors.transparent,
                        child: EditPasswordTFs(
                          title: 'Email Address',
                          controller: _emailTEC,
                          pass: false,
                          onSubmitted: (_) {
                            _password.requestFocus();
                          },
                        ),
                      ),
                    ),
                    SizeTransition(
                      sizeFactor: CurvedAnimation(
                        curve: Curves.fastOutSlowIn,
                        parent: passwordController,
                      ),
                      child: EditPasswordTFs(
                        title: 'Password',
                        myFocusNode: _password,
                        controller: _passwordTEC,
                        onSubmitted: (_) => validateThenEdit(),
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
                            'Edit Email',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

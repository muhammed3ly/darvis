import 'dart:math';

import 'package:chat_bot/providers/categories.dart';
import 'package:chat_bot/providers/users.dart';
import 'package:chat_bot/screens/chat_screen.dart';
import 'package:chat_bot/screens/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = '/login';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String email = '', password = '';
  bool _isSigning;
  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final emailController = TextEditingController();

  final passwordController = TextEditingController(text: "emailController");
  FocusNode passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _isSigning = false;
  }

  @override
  void dispose() {
    passwordFocus.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final valid = formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (!valid) return;
    setState(() {
      _isSigning = true;
    });
    formKey.currentState.save();
    try {
      email = email.trim();
      password = password.trim();
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(Duration(seconds: 10), onTimeout: () {
        throw Exception('Check your internet connection');
      });
      final cats = await Provider.of<User>(context, listen: false).loadData();
      Provider.of<Categories>(context, listen: false).setCategories(cats);
      Navigator.of(context).pushReplacementNamed(ChatScreen.routeName);
    } on PlatformException catch (error) {
      var message = error.message;
      if (message == 'An internal error has occurred. [ 7: ]')
        message = 'an error occurred, please try again';
      if (mounted) {
        setState(() {
          _isSigning = false;
        });
      }
      Get.rawSnackbar(
        messageText: Text(
          message,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red[700],
      );
    } catch (error) {
      var message = error.message;
      if (message == 'An internal error has occurred. [ 7: ]')
        message =
            'an error occurred, please check your internet connection and try again';
      if (mounted) {
        setState(() {
          _isSigning = false;
        });
      }
      Get.rawSnackbar(
        messageText: Text(
          message,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red[700],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: Color.fromRGBO(244, 240, 247, 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 25),
                        height: height * 0.25,
                        child: Image.asset('assets/images/logo.jpg'),
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: width * 0.09,
                              ),
                              padding:
                                  EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      'Email Address',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color.fromRGBO(53, 77, 175, 1),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    onSaved: (value) => email = value,
                                    onChanged: (value) {
                                      setState(() {
                                        email = value;
                                      });
                                    },
                                    onEditingComplete: () =>
                                        passwordFocus.requestFocus(),
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    key: ValueKey('email'),
                                    style: TextStyle(fontSize: 13),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: 'Ex. JohnMac@gmail.com',
                                      hintStyle: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      errorStyle: TextStyle(
                                          color: Colors.red, height: 0.5),
                                    ),
                                    validator: (email) {
                                      if (email.isEmpty)
                                        return 'enter your email address';
                                      if (!email.contains('@'))
                                        return 'enter a valid email address';
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 8,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: width * 0.09,
                              ),
                              padding:
                                  EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      'Password',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color.fromRGBO(53, 77, 175, 1),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    focusNode: passwordFocus,
                                    onSaved: (value) => password = value,
                                    onChanged: (value) {
                                      setState(() {
                                        password = value;
                                      });
                                    },
                                    onFieldSubmitted: (_) => login(),
                                    key: ValueKey('password'),
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return 'enter your password';
                                      return null;
                                    },
                                    style: TextStyle(fontSize: 13),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: '* * * * * * * * * * *',
                                      hintStyle: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      errorStyle: TextStyle(
                                          color: Colors.red, height: 0.5),
                                    ),
                                    obscureText: true,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            _isSigning
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor,
                                    ),
                                  )
                                : Opacity(
                                    opacity: (email.isEmpty || password.isEmpty)
                                        ? 0.6
                                        : 1.0,
                                    child: Container(
                                      height: min(60, height * 0.09),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(53, 77, 175, 1),
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(28.0),
                                        ),
                                      ),
                                      width: double.infinity,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: width * 0.09,
                                      ),
                                      child: FlatButton(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 60),
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                        onPressed:
                                            (email.isEmpty || password.isEmpty)
                                                ? null
                                                : () => login(),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: _isSigning
                      ? null
                      : () => Navigator.of(context)
                          .pushReplacementNamed(SignUpScreen.routeName),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(53, 77, 175, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    width: width,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    alignment: Alignment.center,
                    child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            ' Sign up.',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
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

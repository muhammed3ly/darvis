import 'package:chat_bot/providers/users.dart';
import 'package:chat_bot/screens/my_favorites.dart';
import 'package:chat_bot/screens/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
//    emailController.value.text = "emailController"
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
      Provider.of<User>(context).isSigning = false;
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pushReplacementNamed(MyFavoritesScreen.routeName);
    } catch (error) {
      if (mounted) {
        setState(() {
          _isSigning = false;
        });
        var message = 'An error occurred';
        if (error.message != null) message = error.message;
        if (error.code == 'ERROR_USER_NOT_FOUND') message = "user not found";
        if (error.code == 'ERROR_WRONG_PASSWORD')
          message = "wrong password! please try again";
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            backgroundColor: Color.fromRGBO(53, 77, 175, 1),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: Color.fromRGBO(244, 240, 247, 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 160,
                            child: Image.asset('assets/images/logo.jpg'),
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  padding: EdgeInsets.only(
                                      left: 10, top: 10, right: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          'Email Address',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Color.fromRGBO(53, 77, 175, 1),
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
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        key: ValueKey('email'),
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black54,
                                        ),
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                          hintText: 'Ex. JohnMac@gmail.com',
                                          hintStyle: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(8),
                                          errorStyle:
                                              TextStyle(color: Colors.red),
                                        ),
                                        validator: (email) {
                                          if (email.isEmpty)
                                            return 'enter your email address';
                                          if (!email.contains('@'))
                                            return 'enter a valid email address';
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  padding: EdgeInsets.only(
                                      left: 10, top: 10, right: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          'Password',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Color.fromRGBO(53, 77, 175, 1),
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
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black54),
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                          hintText: '* * * * * * * * * * *',
                                          hintStyle: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(8),
                                          errorStyle:
                                              TextStyle(color: Colors.red),
                                        ),
                                        obscureText: true,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                _isSigning
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor,
                                        ),
                                      )
                                    : Opacity(
                                        opacity:
                                            (email.isEmpty || password.isEmpty)
                                                ? 0.6
                                                : 1.0,
                                        child: Container(
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(53, 77, 175, 1),
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(28.0),
                                            ),
                                          ),
                                          width: double.infinity,
                                          child: FlatButton(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 60),
                                            child: Text(
                                              'Login',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                            onPressed: (email.isEmpty ||
                                                    password.isEmpty)
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
                    padding: EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

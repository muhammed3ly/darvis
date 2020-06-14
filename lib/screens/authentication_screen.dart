import '../providers/categories.dart';
import '../providers/users.dart';
import 'package:chat_bot/screens/sign_up_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: AuthForm(),
    );
  }
}

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  String email, password;

  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> login() async {
    final valid = formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (!valid) return;
    formKey.currentState.save();
    try {
      AuthResult res = await auth.signInWithEmailAndPassword(
          email: email, password: password);
//
//      final userData = await Firestore.instance
//          .collection('users')
//          .document(res.user.uid)
//          .get();
//      userData.documentID;
//      print(email);
//      print(userData['userName']);
//      print(userData['imageUrl']);
//      print(res.user.uid);
//      Provider.of<User>(context, listen: false).setData(
//          email, userData['userName'], userData['imageUrl'], res.user.uid);
//      final allDocuments = await Firestore.instance
//          .collection('users')
//          .document(res.user.uid)
//          .collection('categories')
//          .getDocuments();
//      print(res.user.uid);
//      print(allDocuments.documents);
//      Provider.of<Categories>(context, listen: false)
//          .set(allDocuments.documents.map((document) {
//        return {
//          'name': document.documentID as String,
//          'imageUrl': document.data['imageUrl'] as String,
//          'isFav': document.data['isFav'] as String,
//        };
//      }).toList());
    } catch (error) {

      var message = 'An error occurred';
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(20),
                    height: height / 5,
                    width: width - 40,
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      fit: BoxFit.fill,
                    )),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              width: width - 20,
              padding:
                  EdgeInsets.only(top: 25, bottom: 20, left: 25, right: 25),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextFormField(
                            onSaved: (value) => email = value,
                            keyboardType: TextInputType.emailAddress,
                            key: ValueKey('email'),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              focusColor: Colors.black,
                              fillColor: Colors.black,
                              labelText: 'Email Address',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25.0),
                                ),
                              ),
                              icon: Icon(Icons.email),
                            ),
                            validator: (email) {
                              if (email.isEmpty)
                                return 'enter your email address';
                              if (!email.contains('@'))
                                return 'enter a valid email address';
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            onSaved: (value) => password = value,
                            key: ValueKey('password'),
                            validator: (value) {
                              if (value.isEmpty) return 'enter your password';
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              icon: Icon(Icons.security),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0))),
                            ),
                            obscureText: true,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FlatButton(
                            padding: EdgeInsets.symmetric(horizontal: 60),
                            child: Text(
                              'Login',
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: () => login(),
                            color: Colors.black26,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          FlatButton(
                            child: Text(
                              'Create an account',
                              style: TextStyle(fontSize: 16),
                            ),
                            color: Colors.black26,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            onPressed: () => Navigator.of(context)
                                .pushNamed(SignUpScreen.routeName),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

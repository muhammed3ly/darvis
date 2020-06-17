import '../screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AuthForm(),
    );
  }
}

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  String email = '', password = '';

  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
        child: Container(
          height: height,
          width: width,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
//              FittedBox(
//                child: Container(
//                  padding:
//                      const EdgeInsets.symmetric(vertical: 60, horizontal: 10),
//                  child: Image.asset(
//                    'assets/images/logo.png',
//                    fit: BoxFit.cover,
//                  ),
//                ),
//              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: <Widget>[
                      FittedBox(
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 60, bottom: 40, left: 10, right: 10),
                          child: Text(
                            'Darvis',
                            style: TextStyle(
                                fontFamily: 'Signatra',
                                fontSize: 120,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TextFormField(
                              onSaved: (value) => email = value,
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                });
                              },
                              keyboardType: TextInputType.emailAddress,
                              key: ValueKey('email'),
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                errorStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.white10,
                                labelText: 'Email Address',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 10),
                                labelStyle: TextStyle(
                                    fontSize: 18, color: Colors.white),
                                border: InputBorder.none,
                              ),
                              validator: (email) {
                                if (email.isEmpty)
                                  return 'enter your email address';
                                if (!email.contains('@'))
                                  return 'enter a valid email address';
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              onSaved: (value) => password = value,
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                });
                              },
                              key: ValueKey('password'),
                              validator: (value) {
                                if (value.isEmpty) return 'enter your password';
                                return null;
                              },
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                              decoration: InputDecoration(
                                errorStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: Colors.white10,
                                labelText: 'Password',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 10),
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                                border: InputBorder.none,
                              ),
                              obscureText: true,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Opacity(
                              opacity: (email.isEmpty || password.isEmpty)
                                  ? 0.5
                                  : 1.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  border: Border.all(color: Colors.white),
                                ),
                                width: double.infinity,
                                child: FlatButton(
                                  padding: EdgeInsets.symmetric(horizontal: 60),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                  onPressed: (email.isEmpty || password.isEmpty)
                                      ? null
                                      : () => login(),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.elliptical(0, 0),
                                    ),
                                  ),
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
              InkWell(
                onTap: () =>
                    Navigator.of(context).pushNamed(SignUpScreen.routeName),
                child: Container(
                  color: Colors.white10,
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
                            fontWeight: FontWeight.w300),
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
    );
  }
}

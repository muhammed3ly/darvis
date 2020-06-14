import 'package:chat_bot/screens/authentication_screen.dart';
import 'package:chat_bot/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/categories.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../providers/users.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/sign-up';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool first = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmedPasswordController = TextEditingController();
  final userNameController = TextEditingController();

  @override
  void didChangeDependencies() {
    if (first) {
      step = 0;
      Provider.of<Categories>(context, listen: false).init();
      first = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    emailController.dispose();

    userNameController.dispose();
    confirmedPasswordController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String email, password, userName;
  final formKey = GlobalKey<FormState>();
  int step = 0;
  File pickedImage;

  void pickImage() async {
    var pickedImageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImageFile == null) return;
    setState(() {
      pickedImage = pickedImageFile;
    });
  }

  void goToForm2() {
    if (!formKey.currentState.validate()) return;
    FocusScope.of(context).unfocus();
    formKey.currentState.save();
    setState(() {
      step++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: step == 0 ? form1() : step == 1 ? form2() : form3(),
    );
  }

  Center form1() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: LinearPercentIndicator(
                width: width - 40,
                lineHeight: 14.0,
                percent: 0,
                backgroundColor: Colors.white,
                progressColor: Colors.black87,
              ),
            ),
            Container(
              height: 3 * height / 4,
              width: width - 30,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: ListView(
                children: <Widget>[
                  Text(
                    'Sign up',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 27,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          onSaved: (value) => email = value,
                          keyboardType: TextInputType.emailAddress,
                          key: ValueKey('email'),
                          style: TextStyle(color: Colors.black),
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
                          controller: emailController,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: userNameController,
                          onSaved: (value) => userName = value,
                          keyboardType: TextInputType.emailAddress,
                          key: ValueKey('User Name'),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            focusColor: Colors.black,
                            fillColor: Colors.black,
                            labelText: 'User Name',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0))),
                            icon: Icon(Icons.message),
                          ),
                          validator: (userName) {
                            if (userName.isEmpty) return 'enter your user name';
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: passwordController,
                          onSaved: (value) => password = value,
                          key: ValueKey('password'),
                          validator: (value) {
                            if (value.isEmpty) return 'enter your password';
                            if (value.length < 6)
                              return 'Password must be at least 6 characters long';
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
                        SizedBox(height: 10),
                        TextFormField(
                          controller: confirmedPasswordController,
                          onSaved: (value) => password = value,
                          key: ValueKey('confirm password'),
                          validator: (value) {
                            formKey.currentState.save();
                            if (value != password || value.isEmpty)
                              return 'password dosen\'t match';
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'confirm password',
                            icon: Icon(Icons.security),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0))),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: FlatButton.icon(
                                label: Text('back'),
                                color: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushReplacementNamed(
                                      AuthScreen.routeName);
                                },
                                icon: Icon(Icons.navigate_before),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: FlatButton.icon(
                                label: Text('Next'),
                                color: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                onPressed: () {
                                  goToForm2();
                                },
                                icon: Icon(Icons.navigate_next),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Center form2() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: LinearPercentIndicator(
                width: width - 40,
                lineHeight: 14.0,
                percent: 0.33,
                animation: true,
                backgroundColor: Colors.white,
                progressColor: Colors.black54,
              ),
            ),
            Container(
              height: 3 * height / 4,
              width: width - 30,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Sign up',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 27,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: pickedImage == null
                              ? null
                              : FileImage(pickedImage),
                        ),
                        FlatButton.icon(
                          textColor: Theme.of(context).primaryColor,
                          onPressed: pickImage,
                          color: Colors.blueGrey,
                          icon: Icon(Icons.image),
                          label: Text(
                            'Add image',
                            style: TextStyle(fontSize: 17, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton.icon(
                            icon: Icon(Icons.navigate_before),
                            label: Text(
                              'Back',
                              style:
                                  TextStyle(fontSize: 17, color: Colors.black),
                            ),
                            color: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            onPressed: () {
                              setState(() {
                                step--;
                              });
                            }),
                        FlatButton.icon(
                            icon: Icon(Icons.navigate_next),
                            label: Text(
                              'Next',
                              style:
                                  TextStyle(fontSize: 17, color: Colors.black),
                            ),
                            color: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            onPressed: pickedImage == null
                                ? null
                                : () {
                                    setState(() {
                                      step++;
                                    });
                                  }),
                      ],
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

  Future<void> createUser() async {
    final auth = FirebaseAuth.instance;
    try {
      AuthResult authResult = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
//      final ref = FirebaseStorage.instance
//          .ref()
//          .child('user_image')
//          .child(authResult.user.uid + '.jpg');
//      await ref.putFile(pickedImage).onComplete;
//      final url = await ref.getDownloadURL();
//      await Firestore.instance
//          .collection('users')
//          .document(authResult.user.uid)
//          .setData({
//        'userName': userName,
//        'email': email,
//        'imageUrl': url,
//      });
//      Provider.of<Categories>(context, listen: false)
//          .categories
//          .forEach((type) {
//        Firestore.instance
//            .collection('users')
//            .document(authResult.user.uid)
//            .collection('categories')
//            .document(type['name'])
//            .setData({
//          'imageUrl': type['imageUrl'],
//          'isFav': type['isFav'],
//        });
//      });
//      Provider.of<User>(context, listen: false)
//          .setData(email, userName, url, authResult.user.uid);
    } catch (error) {
      print(error);
    }
  }

  Center form3() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: LinearPercentIndicator(
              width: width - 40,
              lineHeight: 14.0,
              percent: 0.66,
              animation: true,
              backgroundColor: Colors.white,
              progressColor: Colors.black54,
            ),
          ),
          Container(
            height: 9 * height / 10,
            width: width - 20,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'Sign up',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 27,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'What kind of movies do you like ?',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Expanded(
                  child: Consumer<Categories>(
                    builder: (_, categories, ch) =>
                        categories.categories == null
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : GridView.builder(
                                itemCount: categories.categories.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                ),
                                itemBuilder: (ctx, idx) {
                                  return GridTile(
                                    footer: GridTileBar(
                                      backgroundColor: Colors.black54,
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            categories.categories[idx]['name'],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                categories.toggleFavorite(idx),
                                            child: Icon(
                                                categories.categories[idx]
                                                            ['isFav'] ==
                                                        'true'
                                                    ? Icons.star
                                                    : Icons.star_border),
                                          ),
                                        ],
                                      ),
                                    ),
                                    child: Image.network(
                                      categories.categories[idx]['imageUrl'],
                                      fit: BoxFit.fill,
                                    ),
                                  );
                                },
                              ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton.icon(
                        icon: Icon(Icons.navigate_before),
                        label: Text(
                          'Back',
                          style: TextStyle(fontSize: 17, color: Colors.black),
                        ),
                        color: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        onPressed: () {
                          setState(() {
                            step--;
                          });
                        }),
                    FlatButton.icon(
                      color: Colors.grey,
                      onPressed: createUser,
                      icon: Icon(Icons.done),
                      label: Text(
                        'Finish',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

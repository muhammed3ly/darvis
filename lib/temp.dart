import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/sign-up';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  List<Map<String, String>> categories;
  bool first = true;

  @override
  void didChangeDependencies() {
    if (first) {
      Firestore.instance
          .collection('/movie categories')
          .getDocuments()
          .then((onValue) {
        categories = onValue.documents.map((f) {
          return {
            'name': f['categoryName'] as String,
            'imageUrl': f['imageUrl'] as String,
          };
        }).toList();
      });
      first = false;
    }
    super.didChangeDependencies();
  }

  String email, password;
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                'Sign up',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              margin: EdgeInsets.only(top: height / 5),
            ),
            Container(
              width: width,
              height: height / 2,
              padding:
              EdgeInsets.only(top: 45, bottom: 20, left: 25, right: 25),
              margin: EdgeInsets.only(left: 25, right: 25, top: height / 9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: step == 0
                    ? Form(
                  key: formKey,
                  child: Column(
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
                              borderRadius: BorderRadius.all(
                                  Radius.circular(25.0))),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
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
                              borderRadius: BorderRadius.all(
                                  Radius.circular(25.0))),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 14),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: FlatButton.icon(
                          label: Text('Next'),
                          color: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          onPressed: () {
                            if (!formKey.currentState.validate()) return;
                            formKey.currentState.save();
                            setState(() {
                              step++;
                            });
                          },
                          icon: Icon(Icons.navigate_next),
                        ),
                      )
                    ],
                  ),
                )
                    : step == 1
                    ? Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
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
                            style: TextStyle(
                                fontSize: 17, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 60),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton.icon(
                            icon: Icon(Icons.navigate_before),
                            label: Text(
                              'Back',
                              style: TextStyle(
                                  fontSize: 17, color: Colors.black),
                            ),
                            color: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(25.0),
                            ),
                            onPressed: pickedImage == null
                                ? null
                                : () {
                              setState(() {
                                step--;
                              });
                            }),
                        FlatButton.icon(
                            icon: Icon(Icons.navigate_next),
                            label: Text(
                              'Next',
                              style: TextStyle(
                                  fontSize: 17, color: Colors.black),
                            ),
                            color: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(25.0),
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
                )
                    : Container(
                  height: 500,
                  child: GridView.builder(
                    itemCount: categories.length,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemBuilder: (ctx, idx) {
                      return GridTile(
                        header: Text(
                          categories[idx]['name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        child: Image.network(
                          categories[idx]['imageUrl'],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

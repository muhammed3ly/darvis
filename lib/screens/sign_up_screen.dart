import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';
import '../providers/users.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/sign-up';
  final Function toggleAuthMode;
  SignUpScreen(this.toggleAuthMode);
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool first = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmedPasswordController = TextEditingController();
  final userNameController = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();

  final formKey = GlobalKey<FormState>();

  String email = '', password = '', userName = '', confirmedPassword = '';

  int step = 0;
  File pickedImage;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<Categories>(context, listen: false).init(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return step == 0 ? form1() : step == 1 ? form2() : form3();
          return Container(
            height: double.infinity,
            width: double.infinity,
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
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CircularProgressIndicator(),
                Text(
                  'Loading...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void createUser() async {
    try {
      email = email.trim();
      password = password.trim();
      var categories =
          Provider.of<Categories>(context, listen: false).categories;
      Provider.of<User>(context, listen: false)
          .signUp(email, userName, password, pickedImage, categories);
    } catch (error) {
      print(error);
    }
  }

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    emailController.dispose();
    userNameController.dispose();
    confirmedPasswordController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Center form1() {
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.only(left: 25, right: 25, top: height / 7),
                  child: ListView(
                    children: <Widget>[
                      Text(
                        'Sign up',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Signatra',
                            fontSize: 80,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                });
                              },
                              onEditingComplete: () =>
                                  focusNode1.requestFocus(),
                              onSaved: (value) => email = value,
                              keyboardType: TextInputType.emailAddress,
                              key: ValueKey('email'),
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                errorStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.white10,
                                labelText: 'Email Address',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 10),
                                labelStyle: TextStyle(
                                    fontSize: 16, color: Colors.white),
                                border: InputBorder.none,
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
                              onChanged: (value) {
                                setState(() {
                                  userName = value;
                                });
                              },
                              focusNode: focusNode1,
                              onEditingComplete: () =>
                                  focusNode2.requestFocus(),
                              controller: userNameController,
                              onSaved: (value) => userName = value,
                              keyboardType: TextInputType.emailAddress,
                              key: ValueKey('User Name'),
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                errorStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.white10,
                                labelText: 'User Name',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 10),
                                labelStyle: TextStyle(
                                    fontSize: 16, color: Colors.white),
                                border: InputBorder.none,
                              ),
                              validator: (userName) {
                                if (userName.isEmpty)
                                  return 'enter your user name';
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                });
                              },
                              focusNode: focusNode2,
                              onEditingComplete: () =>
                                  focusNode3.requestFocus(),
                              controller: passwordController,
                              onSaved: (value) => password = value,
                              key: ValueKey('password'),
                              validator: (value) {
                                if (value.isEmpty) return 'enter your password';
                                if (value.length < 6)
                                  return 'Password must be at least 6 characters long';
                                return null;
                              },
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                errorStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.white10,
                                labelText: 'Password',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 10),
                                labelStyle: TextStyle(
                                    fontSize: 16, color: Colors.white),
                                border: InputBorder.none,
                              ),
                              obscureText: true,
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  confirmedPassword = value;
                                });
                              },
                              focusNode: focusNode3,
                              controller: confirmedPasswordController,
                              onSaved: (value) => password = value,
                              key: ValueKey('confirm password'),
                              validator: (value) {
//                                formKey.currentState.save();
                                if (confirmedPassword != password ||
                                    value.isEmpty)
                                  return 'password dosen\'t match';
                                return null;
                              },
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                errorStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.white10,
                                labelText: 'Confirm Password',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 10),
                                labelStyle: TextStyle(
                                    fontSize: 16, color: Colors.white),
                                border: InputBorder.none,
                              ),
                              obscureText: true,
                            ),
                            SizedBox(height: 34),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: FlatButton.icon(
                                    label: Text('back'),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    onPressed: widget.toggleAuthMode,
                                    icon: Icon(Icons.navigate_before),
                                  ),
                                ),
                                Opacity(
                                  opacity: (password.isEmpty ||
                                          email.isEmpty ||
                                          userName.isEmpty ||
                                          confirmedPassword.isEmpty)
                                      ? 0.5
                                      : 1.0,
                                  child: Container(
                                    alignment: Alignment.bottomRight,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Colors.white24,
                                      border: Border.all(color: Colors.white),
                                    ),
                                    child: FlatButton.icon(
                                      label: Text('Next'),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                      onPressed: (password.isEmpty ||
                                              email.isEmpty ||
                                              userName.isEmpty ||
                                              confirmedPassword.isEmpty)
                                          ? null
                                          : goToForm2,
                                      icon: Icon(Icons.navigate_next),
                                    ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  SingleChildScrollView form2() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
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
          children: <Widget>[
            SizedBox(
              height: 70,
            ),
            Text(
              'Sign up',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Signatra', fontSize: 80, color: Colors.white),
            ),
            SizedBox(
              height: 70,
            ),
            CircleAvatar(
              backgroundColor: Colors.white70,
              radius: 80,
              backgroundImage:
                  pickedImage == null ? null : FileImage(pickedImage),
            ),
            SizedBox(
              height: 35,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white24,
                border: Border.all(color: Colors.white),
              ),
              height: 35,
              child: FlatButton.icon(
                onPressed: pickImage,
                icon: Icon(Icons.camera_enhance),
                label: Text('Add image',
                    style: TextStyle(fontSize: 14, color: Colors.black)),
              ),
            ),
            SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  alignment: Alignment.bottomLeft,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    border: Border.all(color: Colors.white),
                  ),
                  child: FlatButton.icon(
                    label: Text('back'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    onPressed: () {
                      setState(() {
                        step--;
                      });
                    },
                    icon: Icon(Icons.navigate_before),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Opacity(
                  opacity: (password.isEmpty ||
                          email.isEmpty ||
                          userName.isEmpty ||
                          confirmedPassword.isEmpty)
                      ? 0.5
                      : 1.0,
                  child: Container(
                    alignment: Alignment.bottomRight,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      border: Border.all(color: Colors.white),
                    ),
                    child: FlatButton.icon(
                      label: Text('Next'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      onPressed: (pickedImage == null)
                          ? null
                          : () {
                              setState(() {
                                step++;
                              });
                            },
                      icon: Icon(Icons.navigate_next),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container form3() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Sign up',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Signatra', fontSize: 80, color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'What kind of movies do you like ?',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Consumer<Categories>(
                builder: (_, categories, ch) => categories.categories == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : GridView.builder(
                        itemCount: categories.categories.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemBuilder: (ctx, idx) {
                          return GridTile(
                            key: ValueKey(categories.categories[idx]['name']),
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
                                    onTap: () => categories.toggleFavorite(idx),
                                    child: Icon(categories.categories[idx]
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.bottomLeft,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    border: Border.all(color: Colors.white),
                  ),
                  child: FlatButton.icon(
                    label: Text('back'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    onPressed: () {
                      setState(() {
                        step--;
                      });
                    },
                    icon: Icon(Icons.navigate_before),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    border: Border.all(color: Colors.white),
                  ),
                  child: _loading
                      ? FlatButton(
                          child: CircularProgressIndicator(),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          onPressed: null,
                        )
                      : FlatButton.icon(
                          onPressed: createUser,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          icon: Icon(Icons.done),
                          label: Text(
                            'Finish',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void goToForm2() {
    if (!formKey.currentState.validate()) return;
    FocusScope.of(context).unfocus();
    formKey.currentState.save();
    setState(() {
      step++;
    });
  }

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
}

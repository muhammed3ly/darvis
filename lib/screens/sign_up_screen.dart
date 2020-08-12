import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../widgets/appbar_without_Drawer.dart';
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

  String email = '', password = '', userName = '', confirmedPassword = '';
  int step = 0;
  File pickedImage;

  void pickImage(ImageSource source) async {
    var pickedImageFile = await ImagePicker.pickImage(
      source: source,
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
//    print(step);
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<Categories>(context, listen: false).init(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return step == 0 ? form3() : step == 1 ? form2() : form3();
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromRGBO(244, 240, 247, 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CircularProgressIndicator(),
                Text(
                  'Loading...',
                  style: TextStyle(color: Color.fromRGBO(53, 77, 175, 1)),
                ),
              ],
            ),
          );
        },
      ),
      appBar: step >= 0 ? CustomAppbar() : null,
    );
  }

  Center form1() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Center(
      child: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          padding: EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
            color: Color.fromRGBO(244, 240, 247, 1),
          ),
          child: Column(
            children: <Widget>[
              FittedBox(
                child: Container(
                  height: 160,
                  child: Image.asset('assets/images/logo.jpg'),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: ListView(
                    children: <Widget>[
                      Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding:
                                  EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black54),
                                    decoration: InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
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
                                      errorStyle: TextStyle(color: Colors.red),
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
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding:
                                  EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      'User name',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color.fromRGBO(53, 77, 175, 1),
                                      ),
                                    ),
                                  ),
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
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black54),
                                    decoration: InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      hintText: 'John M',
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(8),
                                      errorStyle: TextStyle(color: Colors.red),
                                    ),
                                    validator: (userName) {
                                      if (userName.isEmpty)
                                        return 'enter your user name';
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
                              padding:
                                  EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      if (value.isEmpty)
                                        return 'enter your password';
                                      if (value.length < 6)
                                        return 'Password must be at least 6 characters long';
                                      return null;
                                    },
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black54),
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
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
                                      errorStyle: TextStyle(color: Colors.red),
                                    ),
                                    obscureText: true,
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
                              padding:
                                  EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      'Confirm Password',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color.fromRGBO(53, 77, 175, 1),
                                      ),
                                    ),
                                  ),
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
                                      if (confirmedPassword != password ||
                                          value.isEmpty)
                                        return 'password dosen\'t match';
                                      return null;
                                    },
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black54),
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
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
                                      errorStyle: TextStyle(color: Colors.red),
                                    ),
                                    obscureText: true,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: goToForm2,
                              child: Container(
                                height: 50,
                                width: 2 * width / 3,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(53, 77, 175, 1),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(28.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Sign up',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    FlatButton(
                                      child: Container(
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.green,
                                          size: 22,
                                        ),
                                        padding: EdgeInsets.all(3),
//
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: widget.toggleAuthMode,
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
                    children: <Widget>[
                      SizedBox(
                        width: 30,
                      ),
                      Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      Text(
                        'back to login',
                        style: TextStyle(
                          fontSize: 18,
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

  SingleChildScrollView form2() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        height: height - 100,
        decoration: BoxDecoration(
          color: Color.fromRGBO(244, 240, 247, 1),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Avatar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 50,
                        color: Color.fromRGBO(53, 77, 175, 1),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Choose an',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 40, color: Colors.black),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 80,
                    backgroundImage: pickedImage == null
                        ? AssetImage('assets/images/avatar.jpg')
                        : FileImage(pickedImage),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(249, 249, 249, 1),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        height: 40,
                        child: FlatButton.icon(
                          onPressed: () => pickImage(ImageSource.camera),
                          icon: Icon(
                            Icons.camera_enhance,
                            color: Color.fromRGBO(53, 77, 175, 1),
                          ),
                          label: Text('Open camera',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)),
                        ),
                      ),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(249, 249, 249, 1),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: FlatButton.icon(
                            onPressed: () => pickImage(ImageSource.gallery),
                            icon: Icon(
                              Icons.camera_enhance,
                              color: Color.fromRGBO(53, 77, 175, 1),
                            ),
                            label: Text('From gallery',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey))),
                      )
                    ],
                  ),
                  SizedBox(height: 0),
                  SizedBox(
                    height: 15,
                  ),
                  FlatButton.icon(
                    label: Text(
                      (pickedImage == null ? 'Skip for Now' : 'Let\'s Go'),
                      style: TextStyle(
                          color: Color.fromRGBO(53, 77, 175, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    icon: Icon(Icons.navigate_next,
                        color: Color.fromRGBO(53, 77, 175, 1)),
                    color: Color.fromRGBO(244, 240, 247, 1),
                    onPressed: () {
                      setState(() {
                        step++;
                      });
                    },
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  step--;
                });
              },
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
                  children: <Widget>[
                    SizedBox(
                      width: 30,
                    ),
                    Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    Text(
                      'back to Sign Up',
                      style: TextStyle(
                        fontSize: 18,
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
    );
  }

  bool _loading = false;

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

  Container form3() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 240, 247, 1),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height -
            100 -
            MediaQuery.of(context).padding.top,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Consumer<Categories>(
                builder: (_, categories, ch) => categories.categories == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView(
                        children: <Widget>[
                          GridView.builder(
                            padding: EdgeInsets.only(top: 16,bottom: 8,right: 8,left: 8),
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: categories.categories.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.9,
                              crossAxisSpacing: 40,
                              mainAxisSpacing: 20,
                            ),
                            itemBuilder: (ctx, idx) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: GridTile(
                                  key: ValueKey(
                                      categories.categories[idx]['name']),
                                  footer: GridTileBar(
//                                backgroundColor: Colors.black54,
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
                                          child: Icon(categories.categories[idx]
                                                      ['isFav'] ==
                                                  'true'
                                              ? Icons.star
                                              : Icons.star_border),
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      Image.network(
                                        categories.categories[idx]['imageUrl'],
                                        fit: BoxFit.fill,
                                      ),
                                      if (categories.categories[idx]['isFav'] ==
                                          'true')
                                        Opacity(
                                          child: Container(
                                            color: Colors.blueAccent,
                                          ),
                                          opacity: 0.6,
                                        ),
                                      if (categories.categories[idx]['isFav'] ==
                                          'true')
                                        Icon(
                                          Icons.favorite_border,
                                          size: 70,
                                          color: Colors.white,
                                        )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          InkWell(
                            onTap: createUser,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(53, 77, 175, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
                              ),
                              width: MediaQuery.of(context).size.width - 150,
                              height: 60,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  SizedBox(
                                    width: 50,
                                  ),
                                  Text(
                                    'Finish',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  FlatButton(
                                    child: Container(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.green,
                                        size: 25,
                                      ),
                                      padding: EdgeInsets.all(3),
//                    height: 70,
//                    width: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
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
            Container(
              height: 110,
              width: double.infinity,
//              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
//                    Color.fromRGBO(255,255, 255, 0.7),
                    Color.fromRGBO(244, 240, 247, 0.8),
                    Color.fromRGBO(244, 240, 247, 0.8),
                    Color.fromRGBO(244, 240, 247, 0.7),
                    Color.fromRGBO(244, 240, 247, 0.6),
                    Color.fromRGBO(244, 240, 247, 0.3),
                    Color.fromRGBO(244, 240, 247, 0.2),
//                    Color.fromRGBO(244, 240, 247, 0.2),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
//              color: Color.fromRGBO(244, 240, 247, 0.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Kind Of Movies',
                    style: TextStyle(
                        fontSize: 35,
                        color: Color.fromRGBO(53, 77, 175, 1),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'do you prefer ?                        ',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 19,
                      color: Color.fromRGBO(92, 92, 92, 1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Container(
//                  alignment: Alignment.bottomLeft,
//                  height: 35,
//                  decoration: BoxDecoration(
//                    color: Colors.white24,
//                    border: Border.all(color: Colors.white),
//                  ),
//                  child: FlatButton.icon(
//                    label: Text('back'),
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(25.0),
//                    ),
//                    onPressed: () {
//                      setState(() {
//                        step--;
//                      });
//                    },
//                    icon: Icon(Icons.navigate_before),
//                  ),
//                ),
//                Container(
//                  alignment: Alignment.bottomRight,
//                  height: 35,
//                  decoration: BoxDecoration(
//                    color: Colors.white24,
//                    border: Border.all(color: Colors.white),
//                  ),
//                  child: _loading
//                      ? FlatButton(
//                          child: CircularProgressIndicator(),
//                          shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(25.0),
//                          ),
//                          onPressed: null,
//                        )
//                      : FlatButton.icon(
//                          onPressed: createUser,
//                          shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(25.0),
//                          ),
//                          icon: Icon(Icons.done),
//                          label: Text(
//                            'Finish',
//                            style: TextStyle(fontSize: 16),
//                          ),
//                        ),
//                ),
//              ],
//            ),
//          ),
          ],
        ),
      ),
    );
  }
}

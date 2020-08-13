import 'dart:io';

import 'package:chat_bot/screens/my_favorites.dart';
import 'package:chat_bot/screens/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../widgets/appbar_without_Drawer.dart';
import '../providers/categories.dart';
import '../providers/users.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();

  final formKey = GlobalKey<FormState>();

  String email = '', password = '', userName = '', confirmedPassword = '';

  int step = 0;
  bool signingUp;
  File pickedImage;

  @override
  void initState() {
    super.initState();
    Provider.of<Categories>(context, listen: false).categories = null;
    signingUp = false;
  }

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
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<Categories>(context, listen: false).init(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return WillPopScope(
                onWillPop: () async {
                  return Future.value(!signingUp);
                },
                child: step == 0 ? form1() : step == 1 ? form2() : form3());
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
      appBar: step >= 1 ? CustomAppbar() : null,
    );
  }

  void createUser() async {
    try {
      setState(() {
        signingUp = true;
      });
      email = email.trim();
      password = password.trim();
      var categories =
          Provider.of<Categories>(context, listen: false).categories;
      await Provider.of<User>(context, listen: false)
          .signUp(email, userName, password, pickedImage, categories);
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(MyFavoritesScreen.routeName);
      }
    } on PlatformException catch (error) {
      if (mounted) {
        setState(() {
          signingUp = false;
        });
      }
      Get.rawSnackbar(
        messageText: Text(
          error.message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[700],
      );
    } catch (error) {
      if (mounted) {
        setState(() {
          signingUp = false;
        });
      }
      debugPrint(error);
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

  Widget form1() {
    final width = MediaQuery.of(context).size.width;
    final height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Color.fromRGBO(244, 240, 247, 1),
          ),
          child: Column(
            children: <Widget>[
              FittedBox(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
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
                                      fontSize: 16,
                                    ),
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: 'Ex. JohnMac@gmail.com',
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      errorStyle: TextStyle(
                                        color: Colors.red,
                                        height: 0.5,
                                      ),
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
                                      fontSize: 16,
                                    ),
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: 'John M',
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      errorStyle: TextStyle(
                                        color: Colors.red,
                                        height: 0.5,
                                      ),
                                    ),
                                    validator: (userName) {
                                      if (userName.isEmpty)
                                        return 'enter your user name';
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 8,
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
                                      fontSize: 16,
                                    ),
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: '* * * * * * * * * * *',
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                      isDense: true,
                                      errorStyle: TextStyle(
                                        color: Colors.red,
                                        height: 0.5,
                                      ),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                    ),
                                    obscureText: true,
                                  ),
                                  SizedBox(
                                    height: 8,
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
                                      fontSize: 16,
                                    ),
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: '* * * * * * * * * * *',
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                      isDense: true,
                                      errorStyle: TextStyle(
                                        color: Colors.red,
                                        height: 0.5,
                                      ),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                    ),
                                    obscureText: true,
                                  ),
                                  SizedBox(
                                    height: 8,
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
                                      onPressed: null,
                                      child: Container(
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.green,
                                          size: 22,
                                        ),
                                        padding: EdgeInsets.all(3),
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
                onTap: () => Navigator.of(context)
                    .pushReplacementNamed(SignInScreen.routeName),
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
                        ? AssetImage('assets/images/Author__Placeholder.png')
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

  Container form3() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 240, 247, 1),
      ),
      child: Container(
//        height: MediaQuery.of(context).size.height -
//            100 -
//            MediaQuery.of(context).padding.top,
        child: Stack(
          children: <Widget>[
            Consumer<Categories>(
              builder: (_, categories, ch) => categories.categories == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        GridView.builder(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.1,
                            bottom: 8,
                          ).add(
                            EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                          ),
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: categories.categories.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.6,
                            crossAxisSpacing: 40,
                          ),
                          itemBuilder: (ctx, idx) {
                            return Column(
                              children: [
                                Flexible(
                                  flex: 13,
                                  child: Container(
                                    key: ValueKey(
                                        categories.categories[idx]['name']),
                                    child: GestureDetector(
                                      onTap: () =>
                                          categories.toggleFavorite(idx),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: Image.network(
                                              categories.categories[idx]
                                                  ['imageUrl'],
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: AnimatedOpacity(
                                              duration:
                                                  Duration(milliseconds: 200),
                                              child: Container(
                                                color: Colors.blueAccent,
                                              ),
                                              opacity:
                                                  categories.categories[idx]
                                                              ['isFav'] ==
                                                          'true'
                                                      ? 0.6
                                                      : 0,
                                            ),
                                          ),
                                          Icon(
                                            Icons.favorite_border,
                                            size: categories.categories[idx]
                                                        ['isFav'] ==
                                                    'true'
                                                ? 70
                                                : 0,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 5,
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  child: Text(
                                    categories.categories[idx]['name'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(77, 75, 78, 1),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 50,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        InkWell(
                          onTap: createUser,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 15).add(
                              EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(53, 77, 175, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                            ),
                            height: 60,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                AnimatedSwitcher(
                                  duration: Duration(milliseconds: 200),
                                  child: signingUp
                                      ? CircularProgressIndicator()
                                      : FlatButton(
                                          onPressed: null,
                                          child: Container(
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.green,
                                              size: 25,
                                            ),
                                            padding: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
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
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                top: 15,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(244, 240, 247, 1),
                    Color.fromRGBO(244, 240, 247, 0.9),
                    Color.fromRGBO(244, 240, 247, 0.8),
                    Color.fromRGBO(244, 240, 247, 0.7),
                    Color.fromRGBO(244, 240, 247, 0.6),
                    Color.fromRGBO(244, 240, 247, 0.5),
                    Colors.white.withOpacity(0)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: signingUp
                        ? null
                        : () {
                            setState(() {
                              step--;
                            });
                          },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).primaryColor,
                      size: 40,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Kind Of Movies',
                        style: TextStyle(
                            fontSize: 35,
                            color: Color.fromRGBO(53, 77, 175, 1),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'do you prefer ?',
                        style: TextStyle(
                          fontSize: 19,
                          color: Color.fromRGBO(92, 92, 92, 1),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

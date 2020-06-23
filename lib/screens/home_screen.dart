import 'package:chat_bot/providers/categories.dart';
import 'package:chat_bot/providers/users.dart';
import 'package:chat_bot/screens/temp_splash.dart';
import 'package:chat_bot/widgets/home_navigator.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading;
  @override
  void initState() {
    super.initState();
    _isLoading = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      Provider.of<User>(context, listen: false).loadData().then((cats) {
        Provider.of<Categories>(context, listen: false).set(cats);
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return !_isLoading ? HomeNavigator() : TempSplashScreen();
  }
}

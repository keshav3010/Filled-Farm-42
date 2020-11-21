import 'dart:io';
import 'package:farmersapp/Components/FlushBarWidget.dart';
import 'package:farmersapp/Components/constants.dart';
import 'package:farmersapp/Components/data.dart';
import 'package:farmersapp/Login/LoginScreen.dart';
import 'package:farmersapp/Components/MySlide.dart';
import 'package:farmersapp/Main%20Screens/AllScreens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Constants _constants;
  @override
  void initState() {
    super.initState();
    _constants = Constants();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _checkLogin();
        return;
      }
    } on SocketException catch (_) {
      Navigator.push(context, MySlide(page: LoginScreen()));
      ShowFlushBar().showFlushBar(context, 'Warning', 'No Internet Access');
      return;
    }
  }

  Future _checkLogin() async {
    try {
      FirebaseAuth.instance.authStateChanges().listen(
        (User user) {
          if (user == null) {
            print("Signed out daw");
            Navigator.push(context, MySlide(page: LoginScreen()));
          } else {
            print('${user.email} ${user.displayName}');
            Provider.of<Data>(context, listen: false).setUser(user);
            Navigator.push(context, MySlide(page: AllScreens()));
            print("signed in daw");
            print(user.email);
          }
        },
      );
    } on FirebaseException catch (_fe) {
      print('Splash screen Firebase Exception daawww $_fe');
      Navigator.push(context, MySlide(page: LoginScreen()));
    } catch (e) {
      print('Splash screen try catch daww $e');
      Navigator.push(context, MySlide(page: LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: _constants.backgroundColorLogin,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: screenSize.height,
              child: Hero(
                tag: 'appLogo',
                child: Image.asset(
                  'assets/logo/logo.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmersapp/Components/data.dart';
import 'package:farmersapp/Main%20Screens/AllScreens.dart';
import 'package:farmersapp/Components/FlushBarWidget.dart';
import 'package:farmersapp/Components/MySlide.dart';
import 'package:farmersapp/Components/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Constants _constants;
  ShowFlushBar _showFlushBar;
  GoogleTranslator translator;

  final _firestoredb = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  bool isSpinning = false;

  @override
  void initState() {
    super.initState();
    _initializeComponents();
  }

  void _initializeComponents() {
    _constants = Constants();
    _showFlushBar = ShowFlushBar();
    translator = GoogleTranslator();
  }

  Future<void> _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        signInWithGoogle();
        return;
      }
    } on SocketException catch (_) {
      _showFlushBar.showFlushBar(context, 'Warning', 'No internet access');
      return;
    }
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      isSpinning = true;
    });
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount googleSignInAccount =
          await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User user = authResult.user;

      if (user != null) {
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);
        final User currentUser = _auth.currentUser;
        assert(user.uid == currentUser.uid);
        print(user.uid);
        await _firestoredb
            .collection(user.email)
            .doc('credentials')
            .get()
            .then((DocumentSnapshot snapshot) {
          if (!snapshot.exists) {
            _firestoredb
                .collection(user.email.toString())
                .doc('credentials')
                .set({
              'name': user.displayName,
              'email': user.email,
              'photoUrl': user.photoURL,
              'phoneNumber': user.phoneNumber,
              'uid': user.uid
            });

            _firestoredb.collection(user.email).doc('rating').set({
              'rating': 0,
              'reviewers': 0,
            });
          }
        });

        Provider.of<Data>(context, listen: false).setUser(user);
        print('Sign in with GOOGLE SUCCEDEED');
        print('DISPLAY NAME:   ${user.displayName}');
        print('EMAIL:  ${user.email}');

        Navigator.push(context, MySlide(page: AllScreens()));
        // await _firestoredb
        //     .collection(user.email)
        //     .doc('mobileVerification')
        //     .get()
        //     .then((DocumentSnapshot snapshot) {
        //   if (!snapshot.exists) {
        //     setState(() {
        //       isSpinning = false;
        //     });
        //     Navigator.push(
        //       context,
        //       MySlide(
        //         page: MobileVerificationScreen(),
        //       ),
        //     );
        //   } else {
        //     Map<dynamic, dynamic> values = snapshot.data();
        //     values.forEach((key, value) {
        //       if (key.toString() == 'verified') {
        //         if (value.toString() == 'no') {
        //           setState(() {
        //             isSpinning = false;
        //           });
        //           Navigator.push(
        //             context,
        //             MySlide(
        //               page: MobileVerificationScreen(),
        //             ),
        //           );
        //         } else if (value.toString() == 'yes') {
        //           setState(() {
        //             isSpinning = false;
        //           });
        //           Navigator.push(context, MySlide(page: ProfileScreen()));
        //         }
        //       }
        //     });
        //   }
        // });

      }
    } on FirebaseException catch (_fe) {
      setState(() {
        isSpinning = false;
      });
      _showFlushBar.showFlushBar(
          context, 'Alert', 'An error occured while trying to sign in');
      print('Firebase auth exception google sign in $_fe');
    } on NoSuchMethodError catch (_nsme) {
      setState(() {
        isSpinning = false;
      });
      _showFlushBar.showFlushBar(
          context, 'Alert', 'An error occured while trying to sign in');
      print("No such method error google sign in $_nsme");
    } catch (e) {
      setState(() {
        isSpinning = false;
      });
      print('Google sign in error $e');
      _showFlushBar.showFlushBar(
          context, 'Alert', 'An error occured while trying to sign in');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return;
      },
      child: Scaffold(
        backgroundColor: _constants.backgroundColorLogin,
        body: SafeArea(
          child: ModalProgressHUD(
            inAsyncCall: isSpinning,
            child: Container(
              height: screenSize.height,
              child: Stack(
                children: [
                  Positioned(
                    bottom: screenSize.height * 0.2,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: screenSize.height,
                      child: Hero(
                        tag: 'appLogo',
                        child: Image.asset(
                          'assets/logo/logo.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 100,
                        left: screenSize.width * .2,
                        right: screenSize.width * .2,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          _checkConnection();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.blue[800],
                          ),
                        ),
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/logo/GoogleLogo.png',
                                width: 30,
                                height: 30,
                              ),
                              SizedBox(width: 20),
                              Text(
                                'SIGN IN WITH GOOGLE',
                                style: _constants.style
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

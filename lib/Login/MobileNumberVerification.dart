// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:farmersapp/Components/FlushBarWidget.dart';
// import 'package:farmersapp/Components/constants.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:farmersapp/Main%20Screens/Profile%20Screens/ProfileScreen.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'package:farmersapp/Components/data.dart';
// import 'package:provider/provider.dart';

// class MobileVerificationScreen extends StatefulWidget {
//   @override
//   _MobileVerificationScreenState createState() =>
//       _MobileVerificationScreenState();
// }

// class _MobileVerificationScreenState extends State<MobileVerificationScreen> {
//   TextEditingController _controller;
//   ShowFlushBar _showFlushBar;
//   Constants _constants;
//   String _enteredPhoneNumber;
//   bool isSpinning = false, codeSent = false;
//   String verificationId;
//   FirebaseFirestore _firestoredb;
//   FirebaseAuth _firebaseAuth;

//   @override
//   void initState() {
//     super.initState();
//     _initializeComponents();
//   }

//   void _initializeComponents() {
//     _controller = TextEditingController();
//     _constants = Constants();
//     _showFlushBar = ShowFlushBar();
//     _firestoredb = FirebaseFirestore.instance;
//     _firebaseAuth = FirebaseAuth.instance;
//   }

//   initAuth({BuildContext context, String phoneNumber}) async {
//     final PhoneVerificationCompleted verificationCompleted =
//         (AuthCredential phoneAuthCredential) async {
//       print('verified');
//       // final AuthResult authResult = await _firebaseAuth.signInWithCredential(phoneAuthCredential);
//       final UserCredential authResult =
//           await _firebaseAuth.signInWithCredential(phoneAuthCredential);
//       if (authResult.user != null) {}
//     };

//     // final PhoneVerificationFailed verificationFailed = (AuthException authException) {
//     final PhoneVerificationFailed verificationFailed =
//         (FirebaseAuthException authException) {
//       //TODO: handle verification failed exceptions
//       print('Auth Exception is ${authException.message}');
//     };

//     final PhoneCodeSent codeSent =
//         (String verificationId, [int forceResendingToken]) async {
//       this.verificationId = verificationId;
//       print('codesent');
//     };

//     final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
//         (String verificationId) {
//       //TODO: handle timeouts
//       this.verificationId = verificationId;
//     };

//     await _firebaseAuth.verifyPhoneNumber(
//         phoneNumber: phoneNumber,
//         verificationCompleted: verificationCompleted,
//         verificationFailed: verificationFailed,
//         codeSent: codeSent,
//         codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
//         timeout: Duration(seconds: 60));
//   }

//   Future<void> phoneNumberVerification() async {
//     print(_enteredPhoneNumber);

//     await _firebaseAuth.verifyPhoneNumber(
//       phoneNumber: _enteredPhoneNumber,
//       timeout: Duration(seconds: 5),
//       verificationCompleted: (AuthCredential authResult) {
//         print('Verification completed');
//         // await _firestoredb
//         //     .collection(Provider.of<Data>(context, listen: false).user.email)
//         //     .doc('mobileVerification')
//         //     .set({'phoneNumber': _enteredPhoneNumber, 'verified': 'yes'});
//         // Navigator.push(context, MySlide(page: ProfileScreen()));
//       },
//       verificationFailed: (FirebaseAuthException authException) {
//         print('${authException.message}');
//         if (authException.code == 'invalid-phone-number') {
//           _showFlushBar.showFlushBar(
//               context, 'Warning', 'Verification failed, Invalid mobile number');
//         } else {
//           _showFlushBar.showFlushBar(context, 'Warning',
//               'Verification failed, check if you have extered the correct mobile number Eg: +919234567898');
//         }
//       },
//       codeSent: (String verId, [int forceResend]) {
//         print('SMS Sent');
//         print('Verification ID $verId');
//         setState(() {
//           codeSent = true;
//         });
//       },
//       codeAutoRetrievalTimeout: (String verId) {
//         print('Time out $verId');
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: _constants.backgroundColorLogin,
//       appBar: AppBar(
//         leadingWidth: 0.0,
//         leading: Container(),
//         backgroundColor: _constants.appBarBackGroundColor,
//         title: Text(
//           'MOBILE VERIFICATION',
//           style: _constants.style,
//         ),
//       ),
//       body: ModalProgressHUD(
//         inAsyncCall: isSpinning,
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Container(
//               height: screenSize.height,
//               padding: EdgeInsets.symmetric(horizontal: 15),
//               child: Column(
//                 children: [
//                   Hero(
//                       tag: 'appLogo',
//                       child: Image.asset('assets/logo/logo.png')),
//                   SizedBox(height: screenSize.height * .1),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text('PHONE NUMBER',
//                         style: _constants.style.copyWith(fontSize: 17)),
//                   ),
//                   SizedBox(height: 10),
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       border: Border.all(
//                         color: Colors.white,
//                         width: 2,
//                       ),
//                     ),
//                     child: TextField(
//                       controller: _controller,
//                       onChanged: (_number) {
//                         print(_number);
//                         this._enteredPhoneNumber = _number;
//                       },
//                       keyboardType: TextInputType.phone,
//                       decoration: InputDecoration(
//                           border: InputBorder.none,
//                           hintText: 'Eg. +9192134567898',
//                           contentPadding: EdgeInsets.only(left: 20)),
//                     ),
//                   ),
//                   SizedBox(height: screenSize.height * .05),
//                   ElevatedButton(
//                     onPressed: () {
//                       initAuth(
//                           context: context, phoneNumber: _enteredPhoneNumber);
//                       // phoneNumberVerification();
//                     },
//                     child: Text('Verify Number', style: _constants.style),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

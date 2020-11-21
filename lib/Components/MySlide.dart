import 'package:flutter/material.dart';

class MySlide extends PageRouteBuilder {
  final Widget page;
  MySlide({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}

// class MySlideSharedAxis extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
      
//     );
//   }
// }

// PageTransitionSwitcher(
//                 duration: const Duration(milliseconds: 300),
//                 reverse: !_isLoggedIn,
//                 transitionBuilder: (
//                   Widget child,
//                   Animation<double> animation,
//                   Animation<double> secondaryAnimation,
//                 ) {
//                   return SharedAxisTransition(
//                     child: child,
//                     animation: animation,
//                     secondaryAnimation: secondaryAnimation,
//                     transitionType: _transitionType,
//                   );
//                 },
//                 child: _isLoggedIn ? _CoursePage() : _SignInPage(),
//               ),
//             ),
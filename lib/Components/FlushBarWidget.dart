import 'package:farmersapp/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';

class ShowFlushBar {
  void showFlushBar(BuildContext context, String title, String message) {
    Flushbar(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
      titleText: Text(
        title == '' ? 'Alert' : title,
        style: Constants().style.copyWith(
          color: Colors.black54,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      messageText: Text(
        message,
        style:Constants().style.copyWith(
          color: Colors.black54,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      duration: Duration(seconds: 2),
      backgroundColor: Colors.white,
      borderRadius: 8,
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context);
  }
}

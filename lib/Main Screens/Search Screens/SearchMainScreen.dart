import 'package:farmersapp/Components/constants.dart';
import 'package:flutter/material.dart';

Constants _constants = Constants();

class SearchMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _constants.backgroundColorAllScreens,
      appBar: AppBar(
        backgroundColor: _constants.appBarBackGroundColor,
        leading: Container(),
        leadingWidth: 0.0,
        title: Text('SEARCH', style: _constants.style),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(),
        ),
      ),
    );
  }
}

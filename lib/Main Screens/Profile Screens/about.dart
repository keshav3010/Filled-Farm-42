import 'package:farmersapp/Components/constants.dart';
import 'package:flutter/material.dart';

Constants _constants = Constants();

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants().backgroundColorAllScreens,
      appBar: AppBar(
        centerTitle: true,
        leading: Container(),
        backgroundColor: Constants().appBarBackGroundColor,
        title: Text('ABOUT', style: Constants().style),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Filled Farm'.toUpperCase(),
                  style: _constants.style
                      .copyWith(fontSize: 30, color: Colors.blueAccent),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                    'We Team 42 bring you our product/application Filled Farm. Filled farm is a mobile/web application which acts as an interface between farmers and vendors directly without the need for middlemen. It comes wIth astunning UI, easy access yet efficient features and a seamless user experience.\n\n"Based on Agriculture Act 2020"',
                    textAlign: TextAlign.center,
                    style: _constants.style),
                SizedBox(
                  height: 40,
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 150),
                  child: Column(
                    children: [
                      Text('from',
                          style: _constants.style.copyWith(fontSize: 16)),
                      Text('S.PREM RAJ',
                          style: _constants.style.copyWith(fontSize: 20))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

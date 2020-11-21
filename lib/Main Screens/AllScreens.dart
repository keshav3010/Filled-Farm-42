import 'package:farmersapp/Components/alertboxwidget.dart';
import 'package:farmersapp/Main%20Screens/Profile%20Screens/ProfileScreen.dart';
import 'package:farmersapp/Main%20Screens/Search%20Screens/SearchMainScreen.dart';
import 'package:flutter/material.dart';

class AllScreens extends StatefulWidget {
  @override
  _AllScreensState createState() => _AllScreensState();
}

class _AllScreensState extends State<AllScreens> {
  final double minWidth = 22;
  PageController pageController =
      PageController(initialPage: 1, keepPage: true);
  int currentPageIndex = 1;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        return AlertBoxWidget().onBackPressed(context);
      },
      child: Scaffold(
        body: SafeArea(
            child: Stack(
          children: [
            PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [SearchMainScreen(), ProfileScreen()],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: screenSize.height * 0.07,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10),
                color: Color(0xFF13161D),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // InkWell(
                    //   // minWidth: minWidth,
                    //   onTap: () {
                    //     if (currentPageIndex != 0) pageController.jumpToPage(0);
                    //     setState(() {
                    //       currentPageIndex = 0;
                    //     });
                    //   },
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       Icon(
                    //         currentPageIndex == 0
                    //             ? Icons.star
                    //             : Icons.star_border_outlined,
                    //         color: currentPageIndex == 0
                    //             ? Colors.red
                    //             : Colors.white,
                    //         size: 28,
                    //       ),
                    //       Text(
                    //         'Featured',
                    //         style: TextStyle(
                    //           fontSize: 10,
                    //           fontWeight: FontWeight.bold,
                    //           color: currentPageIndex == 0
                    //               ? Colors.redAccent
                    //               : Colors.white,
                    //           fontFamily: 'Montserrat',
                    //           letterSpacing: 1,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),

                    InkWell(
                      // minWidth: minWidth,
                      onTap: () {
                        if (currentPageIndex != 0) pageController.jumpToPage(0);
                        setState(() {
                          currentPageIndex = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            currentPageIndex == 0
                                ? Icons.search_outlined
                                : Icons.search_outlined,
                            color: currentPageIndex == 0
                                ? Colors.red
                                : Colors.white,
                            size: 28,
                          ),
                          Text(
                            'Search',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: currentPageIndex == 0
                                  ? Colors.redAccent
                                  : Colors.white,
                              fontFamily: 'Montserrat',
                              letterSpacing: 1,
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      // minWidth: minWidth,
                      onTap: () {
                        if (currentPageIndex != 1) pageController.jumpToPage(1);
                        setState(() {
                          currentPageIndex = 1;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            currentPageIndex == 1
                                ? Icons.person
                                : Icons.person_outline,
                            size: 28,
                            color: currentPageIndex == 1
                                ? Colors.redAccent
                                : Colors.white,
                          ),
                          Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: currentPageIndex == 1
                                  ? Colors.redAccent
                                  : Colors.white,
                              fontFamily: 'Montserrat',
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

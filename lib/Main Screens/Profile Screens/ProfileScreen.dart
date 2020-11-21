import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmersapp/Components/FlushBarWidget.dart';
import 'package:farmersapp/Components/data.dart';
import 'package:farmersapp/Main%20Screens/Profile%20Screens/EditProfileScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:farmersapp/Components/MySlide.dart';
import 'package:farmersapp/Components/constants.dart';
import 'package:farmersapp/Login/LoginScreen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:farmersapp/Main Screens/Profile Screens/DetailsWidget.dart';

Constants _constants = Constants();

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseFirestore _firestoredb;

  @override
  void initState() {
    super.initState();
    _firestoredb = FirebaseFirestore.instance;
    getProfileDetails();
  }

  Future<void> getProfileDetails() async {
    var provider = Provider.of<Data>(context, listen: false);

    // GETTING MOBILE NUMBER

    _firestoredb
        .collection(provider.user.email)
        .doc('credentials')
        .get()
        .then((snapshot) {
      if (snapshot.data() != null) {
        Map<String, dynamic> datavalues = snapshot.data();
        datavalues.forEach((key, value) {
          if (key.toString() == 'phoneNumber') {
            if (value.toString() != 'null' || value.toString() != null) {
              provider.setPhoneNumber(value.toString());
            }
          }
        });
      }
    });

    // GETTING TAGS
    String _tags;
    await _firestoredb
        .collection(provider.user.email)
        .doc('tags')
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.data() != null) {
        Map<dynamic, dynamic> values = snapshot.data();
        values.forEach((key, value) {
          if (key.toString() == 'tags') {
            _tags = value.toString().replaceAll('[', '');
            _tags = _tags.toString().replaceAll(']', '');
            List<String> _tagsList = _tags.split(',');
            provider.setTags(_tagsList);
          }
        });
      } else {
        provider.setTags([]);
      }
    });
    print('haha');

    // GETTING OCCUPATION

    await _firestoredb
        .collection(provider.user.email)
        .doc('occupation')
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.data() != null) {
        Map<dynamic, dynamic> values = snapshot.data();
        values.forEach((key, value) {
          if (key.toString() == 'occupation') {
            provider.setOccupation(value.toString());
          }
        });
      } else {
        provider.setOccupation(null);
      }
    });

    // GETTING FOR SALE ITEMS
    //     final String name;
    // final String quantity;
    // final String photoUrl;
    // final String ownerEmail;
    // final String ownerRating;
    // final String costPer50Kg;

    List<String> _name = [];
    List<String> _quantity = [];
    List<String> _photoUrl = [];
    List<String> _ownerEmail = [];
    List<String> _ownerRating = [];
    List<String> _costPer50Kg = [];
    await _firestoredb
        .collection(provider.user.email)
        .doc('items')
        .collection('forsale')
        .doc('')
        .get()
        .then((snapshot) {
      if (snapshot.data() != null) {
        Map<String, dynamic> datavalues = snapshot.data();
        datavalues.forEach((key, value) {
          if (key == 'name') {
            _name.add(value.toString());
          } else if (key == 'quantity') {
            _quantity.add(value.toString());
          } else if (key == 'ownerEmail') {
            _ownerEmail.add(value.toString());
          } else if (key == 'ownerRating') {
            _ownerRating.add(value.toString());
          } else if (key == 'costPer50Kg') {
            _costPer50Kg.add(value.toString());
          }
          // else if (key == 'photoUrl') {}
        });
      }
    });
    List<ForSaleItem> _items = [];
    for (int i = 0; i < _quantity.length; i++) {
      _items.add(ForSaleItem(
        name: _name[i],
        quantity: _quantity[i],
        ownerEmail: _ownerEmail[i],
        ownerRating: _ownerRating[i],
        costPer50Kg: _costPer50Kg[i],
      ));
    }

    provider.setForSaleItems(_items);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: _constants.backgroundColorAllScreens,
      endDrawer: _DrawerWidget(),
      appBar: AppBar(
        leading: Container(),
        leadingWidth: 0.0,
        backgroundColor: _constants.appBarBackGroundColor,
        title: Text(
          'PROFILE',
          style: _constants.style,
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return getProfileDetails();
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              height: screenSize.height,
              width: screenSize.width,
              child: Stack(
                children: [
                  _CoverImage(screenSize: screenSize),
                  _ProfileDetails(screenSize: screenSize),
                  DetailsWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileDetails extends StatelessWidget {
  final Size screenSize;

  const _ProfileDetails({Key key, this.screenSize}) : super(key: key);

  void sendEmail(String email, BuildContext context) async {
    if (await canLaunch("mailto:$email")) {
      await launch("mailto:$email");
    } else {
      ShowFlushBar().showFlushBar(context, 'Alert', 'Couldnt launch Gmail');
      throw 'Could not launch';
    }
  }

  void _launchPhone(String numm, BuildContext context) async {
    if (await canLaunch("tel:$numm")) {
      await launch("tel:$numm");
    } else {
      ShowFlushBar().showFlushBar(context, 'Alert', 'Couldnt launch Gmail');
      throw 'Could not launch';
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Data>(context);
    Constants _constants = Constants();
    return Positioned(
      top: screenSize.height * 0.12,
      left: screenSize.width * 0.054,
      child: Material(
        color: Colors.transparent,
        elevation: 50,
        child: Container(
          height: screenSize.height * 0.25,
          width: screenSize.width * 0.9,
          padding: EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: screenSize.height * 0.15,
                        width: screenSize.width * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(provider.user.photoURL),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.green[800],
                              width: 5,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.green[200],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.user.displayName.toUpperCase(),
                        style: _constants.style.copyWith(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2),
                      ),
                      SizedBox(height: 5),
                      Text(
                        provider.occupation ?? 'Occuopation not set',
                        style: _constants.style.copyWith(
                            fontSize: provider.occupation == null ? 10 : 18,
                            color: Colors.grey,
                            letterSpacing: 2),
                      ),
                      SizedBox(height: 20),
                      Material(
                        elevation: 50,
                        color: Colors.transparent,
                        child: Container(
                          height: 70,
                          width: screenSize.width * 0.45,
                          decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  tooltip: 'Send Mail',
                                  icon: Icon(
                                    Icons.mail,
                                    color: Colors.red,
                                    size: 25,
                                  ),
                                  onPressed: () =>
                                      sendEmail(provider.user.email, context),
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  tooltip: 'Call',
                                  icon: Icon(
                                    Icons.phone,
                                    color: Colors.blue,
                                    size: 25,
                                  ),
                                  onPressed: () => _launchPhone(
                                      provider.phoneNumber, context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  final Size screenSize;
  const _CoverImage({
    this.screenSize,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenSize.height * 0.26,
      width: screenSize.width,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30)),
        child: Image.asset(
          'assets/logo/logo.png',
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}

class _DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Constants _constants = Constants();
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          height: screenSize.height,
          color: _constants.backgroundColorAllScreens,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: _constants.profilePictureCircleColor,
                      ),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'FILLED FARM',
                          style: _constants.style.copyWith(fontSize: 25),
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MySlide(
                            page: EditProfileScreen(),
                          ),
                        );
                      },
                      title: Text(
                        'EDIT PROFILE',
                        style: _constants.style.copyWith(fontSize: 18),
                      ),
                      trailing: Icon(Icons.person),
                    ),
                    Divider(),
                    ListTile(
                      onTap: () {},
                      title: Text(
                        'CHATS',
                        style: _constants.style.copyWith(fontSize: 18),
                      ),
                      trailing: Icon(Icons.chat),
                    ),
                    Divider(),
                    ListTile(
                      onTap: () {},
                      title: Text(
                        'ABOUT',
                        style: _constants.style.copyWith(fontSize: 18),
                      ),
                      trailing: Icon(Icons.info),
                    ),
                    Divider(),
                    ListTile(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        GoogleSignIn().signOut();
                        Navigator.push(
                          context,
                          MySlide(
                            page: LoginScreen(),
                          ),
                        );
                      },
                      title: Text(
                        'LOG OUT',
                        style: _constants.style.copyWith(fontSize: 18),
                      ),
                      trailing: Icon(Icons.exit_to_app_rounded),
                    ),
                  ],
                ),
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
    );
  }
}

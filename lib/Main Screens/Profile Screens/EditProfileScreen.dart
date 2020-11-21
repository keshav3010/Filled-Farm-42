import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farmersapp/Components/constants.dart';
import 'package:farmersapp/Components/data.dart';
import 'package:farmersapp/Components/alertboxwidget.dart';
import 'package:vibration/vibration.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

Constants _constants = Constants();

class _EditProfileScreenState extends State<EditProfileScreen> {
  AlertBoxWidget _alertBoxWidget = AlertBoxWidget();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var provider = Provider.of<Data>(context);
    return Scaffold(
      backgroundColor: _constants.backgroundColorAllScreens,
      appBar: AppBar(
        backgroundColor: _constants.appBarBackGroundColor,
        leading: Container(),
        leadingWidth: 0.0,
        title: Text('EDIT PROFILE', style: _constants.style),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  elevation: 50,
                  color: Colors.transparent,
                  child: Container(
                    height: ((screenSize.height * 0.09) *
                            (provider.tags.length / 2)) +
                        provider.tags.length / 3,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'YOUR TAGS',
                              style: _constants.style.copyWith(
                                  fontSize: 20, color: Colors.blueAccent),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                _alertBoxWidget.selectTag(context);
                              },
                              child: Text(
                                'ADD',
                                style: _constants.style.copyWith(
                                    fontSize: 17, color: Colors.blueAccent),
                              ),
                            ),
                          ],
                        ),
                        _TagsStream(),
                      ],
                    ),
                  ),
                ),
                Material(
                  elevation: 50,
                  color: Colors.transparent,
                  child: Container(
                    height: 120,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(20)),
                    margin: EdgeInsets.only(top: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'YOUR OCCUPATION',
                              style: _constants.style.copyWith(
                                  fontSize: 20, color: Colors.blueAccent),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                _alertBoxWidget.setOccupation(context);
                              },
                              child: Text(
                                'CHANGE',
                                style: _constants.style.copyWith(
                                    fontSize: 17, color: Colors.blueAccent),
                              ),
                            ),
                          ],
                        ),
                        _OccupationStream(),
                      ],
                    ),
                  ),
                ),
                if (provider.occupation == 'Vendor' &&
                    provider.occupation != null)
                  Material(
                    elevation: 50,
                    color: Colors.transparent,
                    child: Container(
                      height: 150,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(20)),
                      margin: EdgeInsets.only(top: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'YOUR ORGANIZATION',
                                style: _constants.style.copyWith(
                                    fontSize: 20, color: Colors.blueAccent),
                              ),
                              Spacer(),
                              TextButton(
                                  onPressed: () {
                                    _alertBoxWidget.setOrganization(context);
                                  },
                                  child: Text(
                                    'CHANGE',
                                    style: _constants.style.copyWith(
                                        fontSize: 17, color: Colors.blueAccent),
                                  ))
                            ],
                          ),
                          _OrganizationStream(),
                        ],
                      ),
                    ),
                  ),
                Material(
                  elevation: 50,
                  color: Colors.transparent,
                  child: Container(
                    height: 150,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(20)),
                    margin: EdgeInsets.only(top: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'YOUR NUMBER',
                              style: _constants.style.copyWith(
                                  fontSize: 20, color: Colors.blueAccent),
                            ),
                            Spacer(),
                            TextButton(
                                onPressed: () {
                                  _alertBoxWidget.setNumber(context);
                                },
                                child: Text(
                                  'CHANGE',
                                  style: _constants.style.copyWith(
                                      fontSize: 17, color: Colors.blueAccent),
                                ))
                          ],
                        ),
                        _NumberStream(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrganizationStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Data>(context, listen: false);
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection(provider.user.email)
          .doc('organization')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        if (!snapshot.data.exists) {
          return Text("Not Set", style: _constants.style);
        }
        String _name;
        Map<String, dynamic> datavalues = snapshot.data.data();
        datavalues.forEach((key, value) {
          if (key.toString() == 'organization') {
            if (value.toString() == 'null' || value.toString() == null) {
              _name = 'Set Name';
            } else {
              _name = value.toString();
            }
          }
        });
        return Text(
          _name,
          style: _constants.style.copyWith(fontSize: 18),
        );
      },
    );
  }
}

class _NumberStream extends StatelessWidget {
  const _NumberStream({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Data>(context, listen: false);
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection(provider.user.email)
          .doc('credentials')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        if (!snapshot.data.exists) {
          return Text("Not Set", style: _constants.style);
        }
        String _number;
        Map<String, dynamic> datavalues = snapshot.data.data();
        datavalues.forEach((key, value) {
          if (key.toString() == 'phoneNumber') {
            if (value.toString() == 'null' || value.toString() == null) {
              _number = 'Set Number';
            } else {
              _number = value.toString();
            }
          }
        });
        return Text(
          _number,
          style: _constants.style.copyWith(fontSize: 18),
        );
      },
    );
  }
}

class _OccupationStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Data>(context, listen: false);
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection(provider.user.email)
          .doc('occupation')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        if (!snapshot.data.exists) {
          return Text("Not Set");
        }

        Map<String, dynamic> values = snapshot.data.data();

        return Text(values['occupation'],
            style: _constants.style.copyWith(fontSize: 18));
      },
    );
  }
}

class _TagsStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Data>(context, listen: false);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(provider.user.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        } else if (!snapshot.hasData) {
          return Text('No Tags');
        }
        final messages = snapshot.data.docs;
        List _tags = [];
        for (var mes in messages) {
          String t = mes.data()['tags'];
          if (t != null) {
            t = t.toString().replaceAll('[', '');
            t = t.toString().replaceAll(']', '');
            if (t != '[]' && t != null) _tags = t.split(',');
          }
        }
        print(_tags.length);
        if (_tags.length == 0) {
          print('noo');
          return Text('No tags');
        } else
          return Wrap(
            runSpacing: 15,
            children: [
              for (int i = 0; i < _tags.length; i++)
                _TagsNameContainer(
                  tag: _tags[i],
                )
            ],
          );
      },
    );
  }
}

class _TagsNameContainer extends StatelessWidget {
  final String tag;

  const _TagsNameContainer({Key key, this.tag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        Vibration.vibrate(duration: 15);
        FirebaseFirestore _firestoredb = FirebaseFirestore.instance;
        var provider = Provider.of<Data>(context, listen: false);
        _firestoredb
            .collection(provider.user.email)
            .doc('tags')
            .get()
            .then((snapshot) {
          if (snapshot.data() != null) {
            Map<dynamic, dynamic> values = snapshot.data();
            values.forEach((key, value) {
              if (key.toString() == 'tags') {
                String _tags = value.toString().replaceAll('[', '');
                _tags = _tags.toString().replaceAll(']', '');
                List<String> _tagsList = _tags.split(',');
                print('before trim $_tagsList');
                for (int k = 0; k < _tagsList.length; k++) {
                  _tagsList[k] = _tagsList[k].trim();
                }

                _tagsList.remove(tag.trim());
                print('after trim deleted $_tagsList');
                provider.setTags(_tagsList);
                _firestoredb
                    .collection('crops')
                    .doc('cropSubscribers')
                    .collection(tag.trim())
                    .doc(provider.user.email)
                    .delete();
                if (_tagsList.length == 0) {
                  _firestoredb
                      .collection(provider.user.email)
                      .doc('tags')
                      .delete();
                } else
                  _firestoredb.collection(provider.user.email).doc('tags').set(
                    {'tags': _tagsList.toString()},
                  );
              }
            });
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        margin: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(tag.trim(), style: _constants.style),
      ),
    );
  }
}

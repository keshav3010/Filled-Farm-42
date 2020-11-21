import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmersapp/Components/FlushBarWidget.dart';
import 'package:farmersapp/Components/constants.dart';
import 'package:farmersapp/Components/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class AlertBoxWidget {
  Constants _constants = Constants();
  Future<bool> onBackPressed(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0)), //this right here
          child: Container(
            height: 220,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'ARE YOU SURE?',
                    textAlign: TextAlign.center,
                    style: Constants().style.copyWith(
                          fontSize: 20,
                          color: Colors.red[900],
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    'This will close the application',
                    textAlign: TextAlign.center,
                    style: Constants()
                        .style
                        .copyWith(color: Colors.grey[800], fontSize: 16),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Icon(
                          Icons.clear,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          Vibration.vibrate(duration: 20);
                          SystemNavigator.pop();
                        },
                        child: Icon(
                          Icons.check,
                          color: Colors.red[800],
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> selectTag(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ), //this right here
          child: Container(
            height: 210,
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'SELECT A CROP !',
                    textAlign: TextAlign.center,
                    style: Constants().style.copyWith(
                          fontSize: 20,
                          color: Colors.red[900],
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  alignment: Alignment.center,
                  child: DropdownButtonHideUnderline(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side:
                              BorderSide(width: 1.0, style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                      child: DropdownButton<String>(
                        items: Constants().cropTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        style: Constants().style.copyWith(color: Colors.white),
                        dropdownColor: Colors.grey[850],
                        icon: Icon(
                          Icons.arrow_drop_down_sharp,
                          color: Colors.black,
                          size: 35,
                        ),
                        hint: Text(
                          Provider.of<Data>(context).selectedTag ??
                              'Select tag',
                          style:
                              Constants().style.copyWith(color: Colors.black),
                        ),
                        isExpanded: false,
                        onChanged: (_) {
                          print(_);
                          Provider.of<Data>(context, listen: false)
                              .setSelectedTag(_);
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => _constants.appBarBackGroundColor)),
                    onPressed: () async {
                      var provider = Provider.of<Data>(context, listen: false);
                      FirebaseFirestore _firestoredb =
                          FirebaseFirestore.instance;
                      await _firestoredb
                          .collection(provider.user.email)
                          .doc('tags')
                          .get()
                          .then((DocumentSnapshot snapshot) async {
                        if (!snapshot.exists) {
                          await _firestoredb
                              .collection(provider.user.email)
                              .doc('tags')
                              .set({
                            'tags': [provider.selectedTag].toString()
                          });
                          await _firestoredb
                              .collection('crops')
                              .doc('cropSubscribers')
                              .collection(provider.selectedTag)
                              .doc(provider.user.email)
                              .set({'user': provider.user.email});
                          provider.setTags([provider.selectedTag]);
                          Navigator.pop(context);
                        } else {
                          Map<dynamic, dynamic> values = snapshot.data();
                          print('selected tag ${provider.selectedTag}');
                          values.forEach((key, value) {
                            print(value);
                            if (key.toString() == 'tags') {
                              String _tags =
                                  value.toString().replaceAll('[', '');
                              _tags = _tags.toString().replaceAll(']', '');
                              List<String> _tagsList = _tags.split(',');
                              for (int k = 0; k < _tagsList.length; k++) {
                                _tagsList[k] = _tagsList[k].trim();
                              }
                              print(_tagsList);
                              print(provider.selectedTag);
                              if (_tagsList
                                  .contains(provider.selectedTag.trim())) {
                                ShowFlushBar().showFlushBar(context, 'Alert',
                                    'Crop tag already selected');
                              } else {
                                _tagsList.add(provider.selectedTag);
                                print('tags daw $_tagsList');
                                for (int k = 0; k < _tagsList.length; k++) {
                                  _tagsList[k] = _tagsList[k].trim();
                                }
                                provider.setTags(_tagsList);
                                _firestoredb
                                    .collection(provider.user.email)
                                    .doc('tags')
                                    .set({'tags': _tagsList.toString()});
                                _firestoredb
                                    .collection('crops')
                                    .doc('cropSubscribers')
                                    .collection(provider.selectedTag)
                                    .doc(provider.user.email)
                                    .set({'user': provider.user.email});
                                Navigator.pop(context);
                              }
                            }
                          });
                        }
                      });
                    },
                    child: Text('ADD TAG',
                        style: _constants.style.copyWith(fontSize: 18)),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> setOccupation(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0)), //this right here
          child: Container(
            height: 220,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'SET OCCUPATION!',
                    textAlign: TextAlign.center,
                    style: Constants().style.copyWith(
                          fontSize: 20,
                          color: Colors.red[900],
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: DropdownButtonHideUnderline(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side:
                              BorderSide(width: 1.0, style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                      child: DropdownButton<String>(
                        items: Constants().occupation.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        style: Constants().style.copyWith(color: Colors.white),
                        dropdownColor: Colors.grey[850],
                        icon: Icon(
                          Icons.arrow_drop_down_sharp,
                          color: Colors.black,
                          size: 35,
                        ),
                        hint: Text(
                          Provider.of<Data>(context).occupation ??
                              'Set Occupation',
                          style:
                              Constants().style.copyWith(color: Colors.black),
                        ),
                        isExpanded: false,
                        onChanged: (_) {
                          print(_);
                          Provider.of<Data>(context, listen: false)
                              .setOccupation(_);
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => _constants.appBarBackGroundColor)),
                    onPressed: () async {
                      var provider = Provider.of<Data>(context, listen: false);
                      FirebaseFirestore _firestoredb =
                          FirebaseFirestore.instance;
                      await _firestoredb
                          .collection(provider.user.email)
                          .doc('occupation')
                          .get()
                          .then((snapshot) {
                        if (snapshot.data() == null) {
                          _firestoredb
                              .collection(provider.user.email)
                              .doc('occupation')
                              .set({
                            'occupation': provider.occupation.toString()
                          });
                          Navigator.pop(context);
                        } else {
                          _firestoredb
                              .collection(provider.user.email)
                              .doc('occupation')
                              .update({
                            'occupation': provider.occupation.toString()
                          });
                          Navigator.pop(context);
                        }
                      });
                    },
                    child: Text(
                      'APPLY',
                      style: _constants.style.copyWith(fontSize: 18),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> setNumber(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ), //this right here
          child: Container(
            height: 220,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'SET CONTACT NUMBER ',
                    textAlign: TextAlign.center,
                    style: Constants().style.copyWith(
                          fontSize: 20,
                          color: Colors.red[900],
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[600],
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      Provider.of<Data>(context, listen: false)
                          .setPhoneNumber(value);
                    },
                    style: _constants.style.copyWith(color: Colors.black),
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter Number',
                      hintStyle: _constants.style.copyWith(color: Colors.black),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => _constants.appBarBackGroundColor)),
                    onPressed: () {
                      var provider = Provider.of<Data>(context, listen: false);
                      FirebaseFirestore _firebasedb =
                          FirebaseFirestore.instance;
                      provider.phoneNumber != null
                          ? _firebasedb
                              .collection(provider.user.email)
                              .doc('credentials')
                              .update({'phoneNumber': provider.phoneNumber})
                          : ShowFlushBar().showFlushBar(context, 'Alert',
                              'Mobile number should not be empty');
                      Navigator.pop(context);
                    },
                    child: Text('SET',
                        style: _constants.style.copyWith(fontSize: 18)),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> addSaleItem(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ), //this right here
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            padding: EdgeInsets.only(top: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'ADD YOUR SALE ITEM',
                    textAlign: TextAlign.center,
                    style: Constants().style.copyWith(
                          fontSize: 20,
                          color: Colors.red[900],
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: DropdownButtonHideUnderline(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side:
                              BorderSide(width: 1.0, style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                      child: DropdownButton<String>(
                        items: Constants().cropTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        style: Constants().style.copyWith(color: Colors.white),
                        dropdownColor: Colors.grey[850],
                        icon: Icon(
                          Icons.arrow_drop_down_sharp,
                          color: Colors.black,
                          size: 35,
                        ),
                        hint: Text(
                          Provider.of<Data>(context).selectedTag ??
                              'Select tag',
                          style:
                              Constants().style.copyWith(color: Colors.black),
                        ),
                        isExpanded: false,
                        onChanged: (_) {
                          print(_);
                          Provider.of<Data>(context, listen: false)
                              .setSelectedTag(_);
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[600],
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      Provider.of<Data>(context, listen: false)
                          .setQuantity(value);
                    },
                    style: _constants.style.copyWith(color: Colors.black),
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'ENTER QUANTITY',
                      contentPadding: EdgeInsets.only(left: 15),
                      labelStyle:
                          _constants.style.copyWith(color: Colors.black),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[600],
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      Provider.of<Data>(context, listen: false)
                          .setAmount(value);
                    },
                    style: _constants.style.copyWith(color: Colors.black),
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'ENTER AMOUNT',
                      contentPadding: EdgeInsets.only(left: 15),
                      labelStyle:
                          _constants.style.copyWith(color: Colors.black),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => _constants.appBarBackGroundColor)),
                    onPressed: () {
                      var provider = Provider.of<Data>(context, listen: false);
                      FirebaseFirestore _firebasedb =
                          FirebaseFirestore.instance;
                      ShowFlushBar _showFlushBar = ShowFlushBar();
                      if (provider.selectedTag != null &&
                          provider.enteredAmount != null &&
                          provider.enteredQuantity != null) {

                        // _firebasedb.collection(collectionPath)
                      } else if (provider.selectedTag == null) {
                        _showFlushBar.showFlushBar(
                            context, "Alert", 'Select a tag');
                      } else if (provider.enteredAmount == null) {
                        _showFlushBar.showFlushBar(
                            context, "Alert", 'Enter amount');
                      } else if (provider.enteredQuantity == null) {
                        _showFlushBar.showFlushBar(
                            context, "Alert", 'Enter Quantity');
                      }
                    },
                    child: Text(
                      'ADD ITEM',
                      style: _constants.style.copyWith(fontSize: 18),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

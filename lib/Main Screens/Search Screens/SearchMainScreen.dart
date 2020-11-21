import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmersapp/Components/FlushBarWidget.dart';
import 'package:farmersapp/Components/MySlide.dart';
import 'package:farmersapp/Main%20Screens/Search%20Screens/ViewProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmersapp/Components/constants.dart';
import 'package:farmersapp/Components/data.dart';

Constants _constants = Constants();
FirebaseFirestore _firestoredb = FirebaseFirestore.instance;

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
        actions: [
          Container(
            alignment: Alignment.center,
            child: DropdownButtonHideUnderline(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.all(10),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1.0,
                        style: BorderStyle.solid,
                        color: Colors.white),
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
                    size: 35,
                  ),
                  hint: Text(
                    Provider.of<Data>(context).selectedTag ?? 'Select tag',
                    style: Constants().style.copyWith(),
                  ),
                  isExpanded: false,
                  onChanged: (_) {
                    print(_);
                    Provider.of<Data>(context, listen: false).setSelectedTag(_);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: _GlobalPostsStream(),
          ),
        ),
      ),
    );
  }
}

class _GlobalPostsStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Data>(context);
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('global')
          .where('tag', isEqualTo: provider.selectedTag)
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
        final messages = snapshot.data.docs;
        List<_ForSaleItemContainer> _forSaleContainer = [];
        for (var m in messages) {
          print(m['quantity']);
          print(m['tag']);
          _forSaleContainer.add(_ForSaleItemContainer(
            name: m['name'],
            email: m['email'],
            tag: m['tag'],
            quantity: m['quantity'],
            cost: m['amount'],
            city: m['city'],
            rating: int.parse(m['rating']),
          ));
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: Column(
            children: _forSaleContainer,
          ),
        );
      },
    );
  }
}

class _ForSaleItemContainer extends StatelessWidget {
  final String name;
  final String email;
  final String quantity;
  final String tag;
  final String cost;
  final String city;
  final int rating;
  const _ForSaleItemContainer(
      {Key key,
      this.name,
      this.email,
      this.quantity,
      this.tag,
      this.cost,
      this.city,
      this.rating})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Data>(context);
    return Material(
      color: Colors.transparent,
      elevation: 30,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        height: 170,
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  name.toUpperCase(),
                  style: _constants.style
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Spacer(),
                TextButton(
                  onPressed: provider.occupation == 'Farmer'
                      ? null
                      : () async {
                          await _firestoredb
                              .collection(provider.user.email)
                              .doc('interests')
                              .collection('interests')
                              .doc('$email-$tag')
                              .set({
                            'vendorname': provider.user.displayName,
                            'vendorEmail': provider.user.email,
                            'vendorCity': provider.currentCity,
                            'ownerCity': city,
                            'rating': rating.toString(),
                            'ownerName': name,
                            'ownerEmail': email,
                            'quantity': quantity,
                            'cost': cost,
                            'organization': provider.organization,
                            'tag': tag,
                          });
                          await _firestoredb
                              .collection(email)
                              .doc('interests')
                              .collection('interests')
                              .doc('${provider.user.email}-$tag')
                              .set({
                            'vendorname': provider.user.displayName,
                            'vendorEmail': provider.user.email,
                            'vendorCity': provider.currentCity,
                            'ownerCity': city,
                            'rating': rating.toString(),
                            'ownerName': name,
                            'ownerEmail': email,
                            'quantity': quantity,
                            'cost': cost,
                            'organization': provider.organization,
                            'tag': tag,
                          });

                          ShowFlushBar().showFlushBar(
                              context, 'Alert', 'Added to interested');
                        },
                  child: Text(
                    'INTERSTED',
                    style: _constants.style.copyWith(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
                TextButton(
                  onPressed: provider.occupation == 'Farmer'
                      ? null
                      : () {
                          Navigator.push(
                              context, MySlide(page: ViewProfileScreen()));
                        },
                  child: Text(
                    'VIEW PROFILE',
                    style: _constants.style.copyWith(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tag: $tag',
                      style: _constants.style.copyWith(fontSize: 15),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Quantity: $quantity',
                      style: _constants.style.copyWith(fontSize: 15),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Cost: $cost',
                      style: _constants.style.copyWith(fontSize: 15),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'City: $city',
                      style: _constants.style.copyWith(fontSize: 15),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '$rating ',
                      style: _constants.style.copyWith(fontSize: 16),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow[900],
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

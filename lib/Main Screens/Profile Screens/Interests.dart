import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmersapp/Components/constants.dart';
import 'package:farmersapp/Components/data.dart';

Constants _constants = Constants();
FirebaseFirestore _firestoredb = FirebaseFirestore.instance;

class InterestsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Data>(context);
    return Scaffold(
      backgroundColor: _constants.backgroundColorAllScreens,
      appBar: AppBar(
        centerTitle: true,
        leading: Container(),
        backgroundColor: _constants.appBarBackGroundColor,
        title: Text('INTERESTS', style: _constants.style),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: _InterestsStream(),
            ),
          ),
        ),
      ),
    );
  }
}

class _InterestsStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Data>(context);
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(provider.user.email)
          .doc('interests')
          .collection('interests')
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

        List messages = snapshot.data.docs;

        List<_InterestsContainer> _interestsContaienerList = [];
        for (var m in messages) {
          _interestsContaienerList.add(_InterestsContainer(
            ownerName: m['ownerName'],
            vendorName: m['vendorname'],
            ownerEmail: m['ownerEmail'],
            vendorEmail: m['vendorEmail'],
            quantity: m['quantity'],
            cost: m['cost'],
            rating: m['rating'],
            organization: m['organization'],
            vendorCity: m['vendorCity'],
            ownerCity: m['ownerCity'],
            tag: m['tag'],
          ));
        }

        return Column(
          children: _interestsContaienerList,
        );
      },
    );
  }
}

class _InterestsContainer extends StatelessWidget {
  final String ownerName;
  final String vendorName;
  final String ownerEmail;
  final String vendorEmail;
  final String quantity;
  final String tag;
  final String cost;
  final String rating;
  final String organization;
  final String vendorCity;
  final String ownerCity;
  const _InterestsContainer({
    Key key,
    this.ownerName,
    this.vendorName,
    this.ownerEmail,
    this.vendorEmail,
    this.quantity,
    this.tag,
    this.cost,
    this.rating,
    this.organization,
    this.vendorCity,
    this.ownerCity,
  }) : super(key: key);
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
        height: provider.occupation == 'Vendor' ? 150 : 260,
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (provider.occupation != 'Vendor')
                  Text(
                    organization ?? 'Org',
                    style: _constants.style,
                  ),
                if (provider.occupation == 'Vendor')
                  Text(
                    provider.occupation == 'Vendor'
                        ? ownerName.toUpperCase()
                        : vendorName.toUpperCase(),
                    style: _constants.style
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                Spacer(),
                Text(
                  provider.occupation == 'Vendor' ? ownerEmail : vendorEmail,
                  style: _constants.style
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (provider.occupation != 'Vendor')
              Center(
                child: Text(
                  provider.occupation == 'Vendor'
                      ? ownerName.toUpperCase()
                      : vendorName.toUpperCase(),
                  style: _constants.style
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'PRODUCT DETAILS',
                style: _constants.style.copyWith(fontSize: 15),
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: provider.occupation == 'Farmer'
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: provider.occupation == 'Farmer'
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
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
                  ],
                ),
                if (provider.occupation == 'Vendor')
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
            if (provider.occupation != 'Vendor') SizedBox(height: 20),
            if (provider.occupation != 'Vendor')
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await _firestoredb
                        .collection(provider.user.email)
                        .doc('items')
                        .collection('sold')
                        .doc()
                        .set({
                      'ownerName': ownerName,
                      'vendorName': vendorName,
                      'vendorEmail': vendorEmail,
                      'ownerEmail': ownerEmail,
                      'ownerCity': ownerCity,
                      'vendorCity': vendorCity,
                      'quantity': quantity,
                      'amount': cost,
                      'tag': tag,
                      'rating': rating,
                      'organization': organization,
                    });
                    await _firestoredb
                        .collection(vendorEmail)
                        .doc('items')
                        .collection('sold')
                        .doc()
                        .set({
                      'ownerName': ownerName,
                      'vendorName': vendorName,
                      'vendorEmail': vendorEmail,
                      'ownerEmail': ownerEmail,
                      'ownerCity': ownerCity,
                      'vendorCity': vendorCity,
                      'quantity': quantity,
                      'amount': cost,
                      'tag': tag,
                      'rating': rating,
                      'organization': organization,
                    });

                    await _firestoredb
                        .collection(provider.user.email)
                        .doc('interests')
                        .collection('interests')
                        .doc('$vendorEmail-$tag')
                        .delete();
                    await _firestoredb
                        .collection(vendorEmail)
                        .doc('interests')
                        .collection('interests')
                        .doc('$ownerEmail-$tag')
                        .delete();

                    await _firestoredb
                        .collection(provider.user.email)
                        .doc('items')
                        .collection('forsale')
                        .doc(tag)
                        .delete();
                    await _firestoredb
                        .collection('global')
                        .doc('${provider.user.email}-$tag')
                        .delete();
                  },
                  child: Text('Sell to Vendor'),
                ),
              )
          ],
        ),
      ),
    );
  }
}

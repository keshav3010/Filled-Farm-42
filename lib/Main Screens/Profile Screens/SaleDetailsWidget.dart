import 'package:farmersapp/Components/MySlide.dart';
import 'package:farmersapp/Components/alertboxwidget.dart';
import 'package:farmersapp/Main%20Screens/Profile%20Screens/AllSaleItemsDisplayScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmersapp/Components/constants.dart';
import 'package:farmersapp/Components/data.dart';

Constants _constants = Constants();
AlertBoxWidget _alertBoxWidget = AlertBoxWidget();

class SaleDetailsWidget extends StatelessWidget {
  final bool isLessThan3;
  const SaleDetailsWidget({
    Key key,
    this.isLessThan3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var provider = Provider.of<Data>(context);
    return Material(
      color: Colors.transparent,
      elevation: 50,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: screenSize.height * 0.2,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.grey[900], borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'FOR SALE',
                  style: _constants.style.copyWith(
                    fontSize: 20,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    isLessThan3
                        ? _alertBoxWidget.addSaleItem(context)
                        : Navigator.push(context,
                            MySlide(page: AllSaleItemsDisplayScreen()));
                  },
                  child: Text(
                    isLessThan3 ? 'ADD' : 'VIEW MORE',
                    style: _constants.style.copyWith(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            SingleChildScrollView(
              child: Row(
                children: [
                  for (int i = 0; i < provider.forSaleItems.length; i++)
                    _ForSaleDetailsContainer(
                      item: provider.forSaleItems[i],
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForSaleDetailsContainer extends StatelessWidget {
  final ForSaleItem item;
  const _ForSaleDetailsContainer({
    Key key,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

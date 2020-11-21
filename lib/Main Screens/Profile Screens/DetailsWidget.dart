import 'package:farmersapp/Components/data.dart';
import 'package:farmersapp/Main%20Screens/Profile%20Screens/SaleDetailsWidget.dart';
import 'package:farmersapp/Main%20Screens/Profile%20Screens/SoldDetailsWidget.dart';
import 'package:farmersapp/Main%20Screens/Profile%20Screens/TagsWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var provider = Provider.of<Data>(context);
    return Positioned(
      top: screenSize.height * 0.42,
      left: 20,
      right: 20,
      child: Container(
        height: MediaQuery.of(context).size.height * 2,
        child: Column(
          children: [
            if (provider.occupation != 'Vendor') TagsWidget(),
            if (provider.occupation != 'Vendor') SizedBox(height: 50),
            provider.occupation == 'Farmer'
                ? provider.forSaleItems.length <= 3
                    ? SaleDetailsWidget(isLessThan3: true)
                    : SaleDetailsWidget(isLessThan3: false)
                : SizedBox(),
            SizedBox(height: 50),
            provider.soldItems.length <= 3
                ? SoldDetailsWidget(isLessThan3: true)
                : SoldDetailsWidget(isLessThan3: false),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farmersapp/Components/MySlide.dart';
import 'package:farmersapp/Components/alertboxwidget.dart';
import 'package:farmersapp/Components/constants.dart';
import 'package:farmersapp/Components/data.dart';
import 'package:farmersapp/Main%20Screens/Profile%20Screens/AllSoldItemsDisplayScreen.dart';

Constants _constants = Constants();
AlertBoxWidget _alertBoxWidget = AlertBoxWidget();

class SoldDetailsWidget extends StatelessWidget {
  final bool isLessThan3;
  const SoldDetailsWidget({
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
        height: screenSize.height * 0.25,
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
                  'CLOSED DEALS',
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
                        : Navigator.push(
                            context,
                            MySlide(
                              page: AllSoldItemsDisplayScreen(),
                            ),
                          );
                  },
                  child: isLessThan3 == false
                      ? Text(
                          'VIEW MORE',
                          style: _constants.style.copyWith(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      : SizedBox(),
                ),
              ],
            ),
            SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: isLessThan3
                  ? provider.soldItems.length != 0
                      ? Row(
                          children: [
                            for (int i = 0; i < provider.soldItems.length; i++)
                              _SoldDetailsContainer(
                                item: provider.soldItems[i],
                              )
                          ],
                        )
                      : Container()
                  : Row(
                      children: [
                        for (int i = 0; i < 3; i++)
                          _SoldDetailsContainer(
                            item: provider.soldItems[i],
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

class _SoldDetailsContainer extends StatelessWidget {
  final SoldItems item;
  const _SoldDetailsContainer({
    Key key,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Data>(context);
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Material(
        elevation: 50,
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          height: 120,
          decoration: BoxDecoration(
              color: Colors.white12, borderRadius: BorderRadius.circular(20)),
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    item.tag,
                    style: _constants.style.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.3,
                        color: Colors.redAccent),
                  ),
                  Spacer(),
                  Text(
                    'SOLD',
                    style: _constants.style.copyWith(
                      color: Colors.redAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: provider.occupation == 'Farmer'
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quantity:  ${item.quantity}',
                          style: _constants.style),
                      SizedBox(height: 5),
                      if (provider.occupation != 'Farmer')
                        Text(
                          'Farmer: ${item.ownerName}',
                          style: _constants.style,
                        ),
                      if (provider.occupation == 'Farmer')
                        Text(
                          item.organization == null
                              ? 'Organization: Org'
                              : 'Organization: ${item.organization}',
                          style: _constants.style,
                        ),
                      SizedBox(height: 5),
                      Text('City: ${item.city}', style: _constants.style),
                    ],
                  ),
                  if (provider.occupation != 'Farmer')
                    Row(
                      children: [
                        Text(
                          '${item.rating}',
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
      ),
    );
  }
}

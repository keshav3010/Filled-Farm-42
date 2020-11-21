import 'package:farmersapp/Components/constants.dart';
import 'package:farmersapp/Components/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Constants _constants = Constants();
class TagsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var provider = Provider.of<Data>(context);
    return Material(
      color: Colors.transparent,
      elevation: 50,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: screenSize.height * 0.15,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.grey[900], borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SELLING TAGS',
              style: _constants.style.copyWith(
                fontSize: 20,
                color: Colors.blueAccent,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 15),
            if (provider.tags.length != 0)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < provider.tags.length; i++)
                      _TagsNameContainer(tag: provider.tags[i])
                  ],
                ),
              ),
            if (provider.tags.length == 0)
              Text(
                'No Tags',
                style: _constants.style,
              )
          ],
        ),
      ),
    );
  }
}

class _TagsNameContainer extends StatelessWidget {
  final String tag;

  const _TagsNameContainer({Key key, this.tag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(tag, style: _constants.style),
    );
  }
}

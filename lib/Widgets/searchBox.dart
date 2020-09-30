import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Store/Search.dart';


class SearchBoxDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent
      ) =>
      InkWell(
        onTap: (){
          Route route = MaterialPageRoute(builder: (c) => SearchProduct());
          Navigator.pushReplacement(context, route);
        },
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink, Colors.lightGreenAccent],
                begin: const FractionalOffset(0, 0),
                end: const FractionalOffset(1, 1),
                stops: [0, 1],
                tileMode: TileMode.clamp,
              )),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: InkWell(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.search,
                      color: Colors.blueGrey,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text("Search here"),
                  ),
                ],
              ),
            ),
          ),
        ),
      );



  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}



import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget bottom;
  final String titleText;

  MyAppBar({this.bottom, this.titleText});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.blue[700], Colors.white],
          begin: const FractionalOffset(0, 0),
          end: const FractionalOffset(1, 1),
          stops: [0, 1],
          tileMode: TileMode.clamp,
        )),
      ),
      centerTitle: true,
      title: Text(titleText, style: TextStyle(fontWeight: FontWeight.bold),),
      bottom: bottom,
      leading: BackButton(
        color: Colors.white,
        onPressed: () {
          Route route = MaterialPageRoute(builder: (c) => StoreHome());
          Navigator.pushReplacement(context, route);
        },
      ),
      actions: [
        Stack(
          children: [
            IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.blue[700],
                ),
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (c) => CartPage());
                  Navigator.pushReplacement(context, route);
                }),
            Positioned(
              child: Stack(
                children: [
                  Icon(
                    Icons.brightness_1,
                    size: 20,
                    color: Colors.blue[700],
                  ),
                  Positioned(
                    top: 3,
                    bottom: 4,
                    left: 7,
                    child: Consumer<CartItemCounter>(
                      builder: (context, counter, _) {
                        return Text(
                          (EcommerceApp.sharedPreferences
                                      .getStringList(EcommerceApp.userCartList)
                                      .length -
                                  1)
                              .toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}

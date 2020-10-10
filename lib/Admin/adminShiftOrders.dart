import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminOrderCard.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';

class AdminShiftOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<AdminShiftOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
          title: Text(
            "My Orders",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => UploadPage());
              Navigator.pushReplacement(context, route);
            },
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection("orders").snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemBuilder: (c, index) {
                      return FutureBuilder<QuerySnapshot>(
                        future: Firestore.instance
                            .collection("items")
                            .where("shortInfo",
                                whereIn: snapshot.data.documents[index]
                                    .data[EcommerceApp.productID])
                            .getDocuments(),
                        builder: (c, snap) {
                          return snap.hasData
                              ? AdminOrderCard(
                                  itemCount: snap.data.documents.length,
                                  data: snap.data.documents,
                                  orderId:
                                      snapshot.data.documents[index].documentID,
                                  orderBy: snapshot
                                      .data.documents[index].data["orderBy"],
                                  addressID: snapshot
                                      .data.documents[index].data["addressID"],
                                )
                              : Center(
                                  //  child: circularProgress(),
                                  );
                        },
                      );
                    },
                    itemCount: snapshot.data.documents.length,
                  )
                : Center(
                    // child: circularProgress(),
                    );
          },
        ),
      ),
    );
  }
}

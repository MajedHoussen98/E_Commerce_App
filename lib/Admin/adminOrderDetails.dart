import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Address/address.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/Widgets/orderCard.dart';
import 'package:e_shop/Models/address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

String getOrderId = "";

class AdminOrderDetails extends StatelessWidget {
  final String orderId;
  final String orderBy;
  final String addressID;

  const AdminOrderDetails({Key key, this.orderId, this.orderBy, this.addressID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    getOrderId = orderId;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.fireStore
                .collection(EcommerceApp.collectionOrders)
                .document(getOrderId)
                .get(),
            builder: (c, snapshot) {
              Map dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data.data;
              }
              return snapshot.hasData
                  ? Container(
                      child: Column(
                        children: [
                          AdminStatusBanner(
                            status: dataMap[EcommerceApp.isSuccess],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: 4, left: 16, bottom: 4),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Price: ₪ " +
                                    dataMap[EcommerceApp.totalAmount]
                                        .toString(),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width - 200,
                              decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Center(
                                child: Text(
                                  "Ordered at: " +
                                      DateFormat("dd MMMM, yyyy - hh:mm aa")
                                          .format(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  int.parse(
                                                      dataMap["orderTime"]))),
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: 2,
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: EcommerceApp.fireStore
                                .collection("items")
                                .where("shortInfo",
                                    whereIn: dataMap[EcommerceApp.productID])
                                .getDocuments(),
                            builder: (c, dataSnapshot) {
                              return dataSnapshot.hasData
                                  ? OrderCard(
                                      itemCount:
                                          dataSnapshot.data.documents.length,
                                      data: dataSnapshot.data.documents,
                                    )
                                  : Center(
                                      // child: circularProgress(),
                                      );
                            },
                          ),
                          Divider(
                            height: 2,
                          ),
                          FutureBuilder<DocumentSnapshot>(
                            future: EcommerceApp.fireStore
                                .collection(EcommerceApp.collectionUser)
                                .document(orderBy)
                                .collection(EcommerceApp.subCollectionAddress)
                                .document(addressID)
                                .get(),
                            builder: (c, snap) {
                              return snap.hasData
                                  ? AdminShippingDetails(
                                      model:
                                          AddressModel.fromJson(snap.data.data),
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                        ],
                      ),
                    )
                  : Center(
                      // child: circularProgress(),
                      );
            },
          ),
        ),
      ),
    );
  }
}

class AdminStatusBanner extends StatelessWidget {
  final bool status;

  const AdminStatusBanner({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;
    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Successful" : msg = "UnSuccessful";
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.blue[700], Colors.white],
        begin: const FractionalOffset(0, 0),
        end: const FractionalOffset(1, 1),
        stops: [0, 1],
        tileMode: TileMode.clamp,
      )),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              SystemNavigator.pop();
            },
            child: Container(
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            "Order Shipped " + msg,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 5,
          ),
          CircleAvatar(
            radius: 8,
            backgroundColor: Colors.blue[700],
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminShippingDetails extends StatelessWidget {
  final AddressModel model;

  const AdminShippingDetails({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            "Shipment Details:",
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(children: [
                KeyText(
                  msg: "Name",
                ),
                Text(model.name),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Phone Number",
                ),
                Text(model.phoneNumber),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Flat Number",
                ),
                Text(model.flatNumber),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "City",
                ),
                Text(model.city),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "State",
                ),
                Text(model.state),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Pin code",
                ),
                Text(model.pincode),
              ]),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: InkWell(
              onTap: () {
                confirmParcelShifted(context, getOrderId);
              },
              child: Container(
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    gradient: LinearGradient(
                      colors: [Colors.blue[700], Colors.white],
                      begin: const FractionalOffset(0, 0),
                      end: const FractionalOffset(1, 1),
                      stops: [0, 1],
                      tileMode: TileMode.clamp,
                    )),
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child: Center(
                  child: Text(
                    "Confirm || Parcel Shifted",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  confirmParcelShifted(BuildContext context, String mOrderId) {
    EcommerceApp.fireStore
        .collection(EcommerceApp.collectionOrders)
        .document(mOrderId)
        .delete();

    getOrderId = "";
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => UploadPage()));
    Fluttertoast.showToast(msg: "Parcel has been Shifted. Confirmed.");
  }
}

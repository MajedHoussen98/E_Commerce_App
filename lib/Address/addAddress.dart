import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Models/address.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'address.dart';

class AddAddress extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cFlatHomeNumber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
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
            "Add Address",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => StoreHome());
              Navigator.pushReplacement(context, route);
            },
          ),
        ),
        drawer: MyDrawer(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (formKey.currentState.validate()) {
              final model = AddressModel(
                name: cName.text.trim(),
                state: cState.text.trim(),
                pincode: cPinCode.text,
                city: cCity.text.trim(),
                phoneNumber: cPhoneNumber.text,
                flatNumber: cFlatHomeNumber.text,
              ).toJson();

              //addToFireStore
              EcommerceApp.fireStore
                  .collection(EcommerceApp.collectionUser)
                  .document(EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userUID))
                  .collection(EcommerceApp.subCollectionAddress)
                  .document(DateTime.now().millisecondsSinceEpoch.toString())
                  .setData(model)
                  .then((value) {
                final snack =
                    SnackBar(content: Text("New Address added successfully."));
                scaffoldKey.currentState.showSnackBar(snack);
                FocusScope.of(context).requestFocus(FocusNode());
                formKey.currentState.reset();
              });
            }
            Route route = MaterialPageRoute(builder: (c) => Address());
            Navigator.pushReplacement(context, route);
          },
          label: Text("Done"),
          backgroundColor: Colors.blue[700],
          icon: Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      MyTextField(
                        hint: "Name",
                        controller: cName,
                      ),
                      MyTextField(
                        hint: "Phone number",
                        controller: cPhoneNumber,
                      ),
                      MyTextField(
                        hint: "Flat Number / House Number",
                        controller: cFlatHomeNumber,
                      ),
                      MyTextField(
                        hint: "City",
                        controller: cCity,
                      ),
                      MyTextField(
                        hint: "State / Country",
                        controller: cState,
                      ),
                      MyTextField(
                        hint: "Pin code",
                        controller: cPinCode,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  const MyTextField({Key key, this.hint, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        padding: EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width * 1,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue[200])),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration.collapsed(
              hintText: hint, hintStyle: TextStyle(color: Colors.blue[300])),
          validator: (val) => val.isEmpty ? "Field can not be empty" : null,
        ),
      ),
    );
  }
}

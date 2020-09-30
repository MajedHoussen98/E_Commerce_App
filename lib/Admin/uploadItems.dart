import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptionTextEditingController =
      TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _shortInfoTextEditingController =
      TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return file == null ? displayAdminHomeScreen() : displayAdminUploadScreen();
  }

  displayAdminHomeScreen() {
    return Scaffold(
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
        leading: IconButton(
          icon: Icon(
            Icons.border_color,
            color: Colors.white,
          ),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AdminShiftOrders());
            Navigator.pushReplacement(context, route);
          },
        ),
        actions: [
          FlatButton(
            child: Text(
              "Logout",
              style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => SplashScreen());
              Navigator.pushReplacement(context, route);
            },
          ),
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.blue[700], Colors.white],
        begin: const FractionalOffset(0, 0),
        end: const FractionalOffset(1, 1),
        stops: [0, 1],
        tileMode: TileMode.clamp,
      )),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shop_two,
              color: Colors.white,
              size: 200,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9)),
                child: Text(
                  "Add New Item",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                color: Colors.blue[700],
                onPressed: () => takeImage(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  takeImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (c) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              "Item Image",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: Text("Capture with Camera",
                    style: TextStyle(color: Colors.blue[700])),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: Text("Select from Gallery",
                    style: TextStyle(color: Colors.blue[700])),
                onPressed: pickPhotoFromGallery,
              ),
              SimpleDialogOption(
                child: Text("Cancel", style: TextStyle(color: Colors.blue[700])),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void capturePhotoWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 970, maxHeight: 680);
    setState(() {
      file = imageFile;
    });
  }

  void pickPhotoFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: 970, maxHeight: 680);
    setState(() {
      file = imageFile;
    });
  }

  displayAdminUploadScreen() {
    return Scaffold(
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: clearFormInfo,
        ),
        title: Text(
          "New Product",
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          FlatButton(
            child: Text(
              "Add",
              style: TextStyle(
                  color: Colors.blue[700],
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: uploading ? null : () => uploadImageAndSaveItemInfo(),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading ? circularProgress() : Text(""),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            width: MediaQuery.of(context).size.width * 0.8,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: FileImage(file), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12),
          ),

          ListTile(
            title: TextField(
              style: TextStyle(color: Colors.black),
              controller: _shortInfoTextEditingController,
              decoration: InputDecoration(
                hintText: "Short Info",
                icon: Icon(Icons.info_outline, color: Colors.blue[700],),
                hintStyle: TextStyle(color: Colors.blue[700]),
                border: InputBorder.none,
              ),
            ),
          ),
          Divider(
            color: Colors.blue[700],
          ),


          ListTile(
            title: TextField(
              style: TextStyle(color: Colors.black),
              controller: _titleTextEditingController,
              decoration: InputDecoration(
                hintText: "Title",
                hintStyle: TextStyle(color: Colors.blue[700]),
                icon: Icon(Icons.text_fields, color: Colors.blue[700],),
                border: InputBorder.none,
              ),
            ),
          ),
          Divider(
            color: Colors.blue[700],
          ),
          ListTile(
            title: TextField(
              style: TextStyle(color: Colors.black),
              controller: _descriptionTextEditingController,
              decoration: InputDecoration(
                hintText: "Description",
                icon: Icon(Icons.description, color: Colors.blue[700],),
                hintStyle: TextStyle(color: Colors.blue[700]),
                border: InputBorder.none,
              ),
            ),
          ),
          Divider(
            color: Colors.blue[700],
          ),
          ListTile(
            title: TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black),
              controller: _priceTextEditingController,
              decoration: InputDecoration(
                hintText: "Price",
                icon: Icon(Icons.monetization_on, color: Colors.blue[700],),
                hintStyle: TextStyle(color: Colors.blue[700]),
                border: InputBorder.none,
              ),
            ),
          ),
          Divider(
            color: Colors.blue[700],
          ),
        ],
      ),
    );
  }

  void clearFormInfo() {
    setState(() {
      file = null;
      _descriptionTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _priceTextEditingController.clear();
      _titleTextEditingController.clear();
    });
  }

  uploadImageAndSaveItemInfo() async{
    setState(() {
      uploading = true;
    });
   String imageDownloadUrl = await uploadItemImage(file);
   
   saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadItemImage(File file) async{
    final StorageReference storageReference = FirebaseStorage.instance.ref().child("Items");
    StorageUploadTask uploadTask = storageReference.child("product_$productId.jpg").putFile(file);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  void saveItemInfo(String imageDownloadUrl) {
    final itemsRef = Firestore.instance.collection("items");
    itemsRef.document(productId).setData({
      "title": _titleTextEditingController.text.trim(),
      "shortInfo": _shortInfoTextEditingController.text.trim(),
      "longDescription": _descriptionTextEditingController.text.trim(),
      "price": int.parse(_priceTextEditingController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": imageDownloadUrl,

    });

    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();

      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _priceTextEditingController.clear();

      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              color: Colors.green,
              message: "Uploading Successful",
            );
          });

    });
  }
}

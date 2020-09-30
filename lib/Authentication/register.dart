import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () => _selectAndPicImage(),
              child: CircleAvatar(
                radius: _screenWidth * 0.15,
                backgroundColor: Colors.white,
                backgroundImage:
                    _imageFile == null ? null : FileImage(_imageFile),
                child: _imageFile == null
                    ? Icon(
                        Icons.add_a_photo,
                        size: _screenWidth * 0.15,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    textInputType: TextInputType.name,
                    controller: _nameController,
                    hintText: "Enter your name",
                    iconData: Icons.person,
                    isObscure: false,
                  ),
                  CustomTextField(
                    textInputType: TextInputType.emailAddress,
                    controller: _emailController,
                    hintText: "Enter your email",
                    iconData: Icons.email,
                    isObscure: false,
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: "Enter your password",
                    iconData: Icons.lock,
                    isObscure: true,
                  ),
                  CustomTextField(
                    controller: _cPasswordController,
                    hintText: "Confirm password",
                    iconData: Icons.lock,
                    isObscure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () => _uploadAndSaveImage(),
              color: Colors.pink,
              child: Text(
                "Sign up",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 4,
              width: _screenWidth * 0.8,
              color: Colors.pink,
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectAndPicImage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> _uploadAndSaveImage() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: "Please Selected an image file",
            );
          });
    } else {
      _passwordController.text == _cPasswordController.text
          ? _nameController.text.isNotEmpty &&
                  _emailController.text.isNotEmpty &&
                  _passwordController.text.isNotEmpty &&
                  _cPasswordController.text.isNotEmpty
              ? uploadToStorge()
              : displayDialoge(
                  "please fill up the registration complete form..")
          : displayDialoge("Password do not match.");
    }
  }

  displayDialoge(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  uploadToStorge() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Registering, Please wait...",
          );
        });
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(imageFileName);
    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    await storageTaskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;
      _registerUser();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void _registerUser() async {
    FirebaseUser firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    )
        .then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });

    if (firebaseUser != null) {
      saveUserInfoToFireStore(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUserInfoToFireStore(FirebaseUser firebaseUser) async {
    Firestore.instance.collection("users").document(firebaseUser.uid).setData({
      "uid": firebaseUser.uid,
      "name": _nameController.text.trim(),
      "email": firebaseUser.email,
      "url": userImageUrl,
      EcommerceApp.userCartList: ["garbageValue"],
    });
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userUID, firebaseUser.uid);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userName, _nameController.text.trim());
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userEmail, firebaseUser.email);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
  }
}

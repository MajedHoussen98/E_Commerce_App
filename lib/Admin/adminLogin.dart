import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.pink, Colors.lightGreenAccent],
            begin: const FractionalOffset(0, 0),
            end: const FractionalOffset(1, 1),
            stops: [0, 1],
            tileMode: TileMode.clamp,
          )),
        ),
        title: Text(
          "e_Shop",
          style: TextStyle(
              fontSize: 55, color: Colors.white, fontFamily: "Signatra"),
        ),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final TextEditingController _adminIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.pink, Colors.lightGreenAccent],
          begin: const FractionalOffset(0, 0),
          end: const FractionalOffset(1, 0),
          stops: [0, 1],
          tileMode: TileMode.clamp,
        )),
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/images/admin.png",
                height: 240,
                width: 240,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Admin",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _adminIDController,
                    hintText: "Admin ID",
                    iconData: Icons.person,
                    isObscure: false,
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: "Password",
                    iconData: Icons.lock,
                    isObscure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                _adminIDController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty
                    ? loginAdmin()
                    : showDialog(
                        context: context,
                        builder: (c) {
                          return ErrorAlertDialog(
                            message: "Please write email and password",
                          );
                        });
              },
              color: Colors.pink,
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 4,
              width: _screenWidth * 0.8,
              color: Colors.pink,
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton.icon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AuthenticScreen())),
              icon: Icon(
                Icons.nature,
                color: Colors.pink,
              ),
              label: Text("I'm not Admin",
                  style: TextStyle(
                      color: Colors.pink, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  loginAdmin() {
    Firestore.instance.collection("admins").getDocuments().then((snapshot) {
      snapshot.documents.forEach((result) {
        if (result.data["id"] != _adminIDController.text.trim()) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Your id is not correct"),
          ));
        } else if (result.data["password"] != _passwordController.text.trim()) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Your password is not correct"),
          ));
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Welcome Dear admin, " + result.data["name"]),
          ));
          setState(() {
            _adminIDController.text = "";
            _passwordController.text = "";
          });

          Route route = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorAlertDialog extends StatelessWidget {
  final String message;

  const ErrorAlertDialog({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      key: key,
      content: Text(message),
      actions: <Widget>[
        Center(
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.red,
            child: Center(
              child: Text("OK", style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ),
        )
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorAlertDialog extends StatelessWidget {
  final String message;
  final Color color;
  const ErrorAlertDialog({Key key, this.message, this.color}) : super(key: key);

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
            color: color,
            child: Center(
              child: Text("OK", style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ),
        )
      ],
    );
  }
}

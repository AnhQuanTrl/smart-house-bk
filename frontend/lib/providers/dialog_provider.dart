import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogProvider {
  Future<void> showCustomDialog(String message, BuildContext context,
      {bool isSuccess}) {
    return showDialog(
      context: context,
      builder: (ctx) => CustomDialog(
        isSuccess: isSuccess,
        description: message,
        buttonText: "OK",
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final description, buttonText;
  final bool isSuccess;
  const CustomDialog(
      {Key key, this.isSuccess, this.description, this.buttonText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                  color: isSuccess ? Colors.cyan : Colors.deepOrange,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  )),
              child: Text(
                isSuccess ? "Success" : "Error",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40, bottom: 30),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(); // To close the dialog
                },
                child: Text(
                  buttonText,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

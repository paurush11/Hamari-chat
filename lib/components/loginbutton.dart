import 'package:flutter/material.dart';
class Logintypebutton extends StatelessWidget {
  Logintypebutton({this.colour = Colors.blue , this.onpress , this.value});
  final Color colour;
  final Function onpress;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour ,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onpress,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            value,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  @override
  RoundedButton(this.text, this.colour, this.onPressed); //this.onPressed);
  final String text;
  final Color colour;
  final Function onPressed;
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

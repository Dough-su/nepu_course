import 'package:flutter/material.dart';
import 'package:muse_nepu_course/game/constants.dart';

class ReusableButton extends StatelessWidget {
  final onTap, text;
  ReusableButton({this.onTap, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        textColor: Colors.white,
        color: kProfileContainerColor,
        minWidth: double.infinity,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Text(
          text,
          style: TextStyle(
              fontFamily: 'Paytone',
              fontSize: 25.0,
              fontWeight: FontWeight.w500),
        ),
        onPressed: onTap,
      ),
    );
  }
}

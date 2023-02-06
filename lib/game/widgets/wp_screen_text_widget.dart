import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {

  TextWidget({this.text,this.fontSize,this.fontWeight});

  final text,fontSize,fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'Carter',
        fontSize: fontSize,
      ),
    );
  }
}

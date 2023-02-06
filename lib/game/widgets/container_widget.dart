import 'package:flutter/material.dart';

class ContainerWidget extends StatelessWidget {

  final color, text, textColor;
  ContainerWidget({this.color, this.text, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(28.0),
        ),
        child: LayoutBuilder(
          builder: (context,constraints) => Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: constraints.maxHeight / 1.5,
                color: textColor,
                fontWeight: FontWeight.w900,
                fontFamily: 'Carter',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

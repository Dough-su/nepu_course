import 'package:flutter/material.dart';
import 'package:muse_nepu_course/game/Models/UiLogic.dart';

class CircleAvatarWidget2 extends StatelessWidget {
  final imageName, color, onTap;
  CircleAvatarWidget2({this.imageName, this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 23.0,
        backgroundColor: UI.avatar2Map[imageName],
        child: LayoutBuilder(
          builder: (context, constraints) => Image(
            image: AssetImage("images/$imageName.png"),
            height: constraints.maxHeight * 0.85,
            width: constraints.maxWidth * 0.85,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:muse_nepu_course/game/Models/UiLogic.dart';
import 'package:muse_nepu_course/game/constants.dart';
import 'package:muse_nepu_course/game/widgets/circle_avatar_widget2.dart';

class RowAvatarImages2 extends StatefulWidget {
  @override
  _RowAvatarImages2State createState() => _RowAvatarImages2State();
}

class _RowAvatarImages2State extends State<RowAvatarImages2> {
  @override
  Widget build(BuildContext context) {
    void toggleColor(String name) {
      UI.avatar2Map.keys.forEach((key) {
        UI.avatar2Map[key] = kSettingsBoxColor;
      });
      setState(() {
        UI.avatar2Map[name] = kProfileContainerColor;
        UI.player2ImageName = name;
      });
    }

    return Row(
      children: [
        Text(
          "头像",
          style: kSettingsBoxLetterStyle,
        ),
        Expanded(
            child: CircleAvatarWidget2(
                imageName: 'avatar-1', onTap: () => toggleColor('avatar-1'))),
        Expanded(
            child: CircleAvatarWidget2(
                imageName: 'avatar-2', onTap: () => toggleColor('avatar-2'))),
        Expanded(
            child: CircleAvatarWidget2(
                imageName: 'avatar-3', onTap: () => toggleColor('avatar-3'))),
        Expanded(
            child: CircleAvatarWidget2(
                imageName: 'avatar-4', onTap: () => toggleColor('avatar-4'))),
      ],
    );
  }
}

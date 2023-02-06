import 'package:flutter/material.dart';
import 'package:muse_nepu_course/game/constants.dart';
import 'profile_container_widget.dart';
import 'package:muse_nepu_course/game/Models/UiLogic.dart';

class EntireRowInGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ProfileContainer(
            profileName: UI.player1Name,
            letter: UI.side == "X" ? "X" : "O",
            imageName: UI.player1ImageName),
        Column(
          children: [
            Text(
              "D",
              style: kScoreTextStyle,
            ),
            Text(
              ":",
              style: kScoreTextStyle,
            ),
            Text(
              UI.draws.toString(),
              style: kScoreTextStyle,
            ),
          ],
        ),
        ProfileContainer(
            profileName: UI.player2Name,
            letter: UI.side == "X" ? "O" : "X",
            imageName: UI.player2ImageName),
      ],
    );
  }
}

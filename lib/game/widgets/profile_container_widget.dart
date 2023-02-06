import 'package:flutter/material.dart';
import 'package:muse_nepu_course/game/Models/UiLogic.dart';
import 'package:muse_nepu_course/game/constants.dart';

// ignore: must_be_immutable
class ProfileContainer extends StatelessWidget {
  final profileName, letter, imageName;

  ProfileContainer({this.profileName, this.letter, this.imageName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: UI.finalResult == ""
          ? BoxDecoration(
              color: UI.letterO
                  ? letter == "O"
                      ? kActiveCardColor
                      : kProfileContainerColor
                  : letter == "X"
                      ? kActiveCardColor
                      : kProfileContainerColor,
              borderRadius: BorderRadius.circular(15.0),
              border: UI.letterO
                  ? letter == "O"
                      ? Border.all(color: Colors.white, width: 1.0)
                      : Border.all(
                          color: kGameScreenBackgroundColor, width: 1.5)
                  : letter == "X"
                      ? Border.all(color: Colors.white, width: 1.0)
                      : Border.all(
                          color: kGameScreenBackgroundColor, width: 1.5))
          : UI.finalResult != "Win"
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: kProfileContainerColor,
                )
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: UI.letterX == false
                      ? letter == "X"
                          ? kActiveCardColor
                          : kProfileContainerColor
                      : letter == "O"
                          ? kActiveCardColor
                          : kProfileContainerColor,
                  border: UI.letterX == false
                      ? letter == "X"
                          ? Border.all(color: Colors.white, width: 1.0)
                          : Border.all(
                              color: kGameScreenBackgroundColor, width: 1.5)
                      : letter == "O"
                          ? Border.all(color: Colors.white, width: 1.0)
                          : Border.all(
                              color: kGameScreenBackgroundColor, width: 1.5)),
      width: 135.0,
      height: 150.0,
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
              image: AssetImage("images/$imageName.png"),
              height: constraints.maxHeight * 0.30,
            ),
            Text(
              profileName,
              style: TextStyle(
                fontSize: constraints.maxHeight * 0.12,
                color: Colors.white,
                fontFamily: 'Carter',
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  letter,
                  style: TextStyle(
                    fontSize: constraints.maxHeight * 0.20,
                    fontFamily: 'Paytone',
                    color: letter == "X" ? kLetterXColor : kLetterOColor,
                  ),
                ),
                Text(
                  ":",
                  style: TextStyle(
                    fontFamily: 'Carter',
                    fontSize: constraints.maxHeight * 0.15,
                    color: letter == "X" ? kLetterXColor : kLetterOColor,
                  ),
                ),
                Text(
                  letter == "X" ? UI.xWins.toString() : UI.oWins.toString(),
                  style: TextStyle(
                    fontSize: constraints.maxHeight * 0.20,
                    fontFamily: 'Paytone',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muse_nepu_course/game/constants.dart';
import 'package:muse_nepu_course/game/Models/UiLogic.dart';

class NameTextFieldWidget extends StatelessWidget {
  final setP1, setP2;
  NameTextFieldWidget({this.setP1, this.setP2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "玩家姓名",
            style: kSettingsBoxLetterStyle,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Container(
              child: TextField(
                inputFormatters: [LengthLimitingTextInputFormatter(15)],
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: kTextFieldDecoration.copyWith(
                    hintText: setP1 ? UI.player1Name : UI.player2Name),
                onChanged: (value) {
                  setP1 ? UI.player1Name = value : UI.player2Name = value;
                },
              ),
              height: 45.0,
              width: 115.0,
            ),
          ),
        ],
      ),
    );
  }
}

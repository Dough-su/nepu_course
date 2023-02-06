import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muse_nepu_course/game/constants.dart';
import 'package:muse_nepu_course/game/screens/game_screen.dart';
import 'package:muse_nepu_course/game/widgets/profileContainerRow.dart';
import 'package:muse_nepu_course/game/Models/UiLogic.dart';
import 'package:muse_nepu_course/game/widgets/reusable_button.dart';

class WinningScreen extends StatelessWidget {
  final winningLetter, onTap;
  WinningScreen({this.winningLetter, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGameScreenBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: EntireRowInGameScreen(),
            ),
            Expanded(
              child: DelayedDisplay(
                delay: Duration(milliseconds: 500),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: kGameScreenContainerColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) => Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              height: constraints.maxHeight * 0.70,
                              image: AssetImage('images/${UI.finalResult}.png'),
                            ),
                            UI.finalResult == "Win"
                                ? Center(
                                    child: Text(
                                      "${UI.playerMap[winningLetter]} 赢啦",
                                      style: kResultText.copyWith(
                                          fontSize:
                                              constraints.maxHeight / 10.5),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      "平局",
                                      style: kResultText.copyWith(
                                          fontSize:
                                              constraints.maxHeight / 10.5),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            DelayedDisplay(
              delay: Duration(milliseconds: 850),
              child: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Column(
                  children: [
                    ReusableButton(text: '再来一次！', onTap: onTap),
                    ReusableButton(
                      text: '游戏主页',
                      onTap: () {
                        ui.setAllVars();
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        UI.muteSound = true;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

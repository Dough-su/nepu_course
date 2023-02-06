import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:muse_nepu_course/game/constants.dart';
import 'package:muse_nepu_course/game/widgets/showcasewidget.dart';
import 'package:muse_nepu_course/game/screens/pickup_screen.dart';
import 'package:muse_nepu_course/game/widgets/reusable_button.dart';
import 'package:muse_nepu_course/game/widgets/wp_screen_text_widget.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final keyOne = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => ShowCaseWidget.of(context)!.startShowCase([keyOne]),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGameScreenBackgroundColor,
      appBar: AppBar(
        backgroundColor: kGameScreenBackgroundColor,
        leading: showCaseWidget(keyOne: keyOne),
        title: Center(
            child: TextWidget(
          text: "井字棋",
          fontSize: 30.0,
        )),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) => Text(
                      "X",
                      style: TextStyle(
                          color: kLetterXColor,
                          fontSize: constraints.maxHeight / 3.0,
                          fontFamily: 'Carter'),
                    ),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) => Text(
                      "O",
                      style: TextStyle(
                          color: kLetterOColor,
                          fontSize: constraints.maxHeight / 3.0,
                          fontFamily: 'Carter'),
                    ),
                  ),
                ],
              ),
            ),
            ReusableButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PickUpScreen()),
                );
              },
              text: "选择你的棋子",
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:muse_nepu_course/game/screens/welcome_screen.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
        home: ShowCaseWidget(
      builder: Builder(
        builder: (_) => WelcomeScreen(),
      ),
    ));
  }
}

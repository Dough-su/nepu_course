import 'package:flutter/material.dart';
import 'package:muse_nepu_course/progress.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '东油课表',
      home: WithBuilder(),
    );
  }
}

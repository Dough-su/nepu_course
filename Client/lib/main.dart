import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:muse_nepu_course/home.dart';
import 'package:muse_nepu_course/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notificationUtils.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  //去除debug标签
  debugPaintSizeEnabled = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

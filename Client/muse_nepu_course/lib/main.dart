import 'dart:io';

import 'package:flutter/material.dart';
import 'package:muse_nepu_course/home.dart';
import 'package:muse_nepu_course/login/login.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  //去除debug标签
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  bool isfirst() {
    getApplicationDocumentsDirectory().then((value) {
      File file = new File(value.path + '/course.json');
      file.exists().then((value) {
        if (!value) {
          //如果不存在
          return true; //第一次
        } else {
          return false;
        }
      });
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '东油课表',
      home: isfirst() ? LoginPage() : HomePage(),
    );
  }
}

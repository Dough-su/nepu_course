import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:muse_nepu_course/global.dart';
import 'package:muse_nepu_course/home.dart';

class jpushs {
  //判断是否ios
  static bool isIOS = Platform.isIOS;
  static String rid = '';
  void addlistenerandinit() {
    JPush jpush = new JPush();
    jpush.addEventHandler(
      // 接收通知回调方法。
      onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");
      },
      // 点击通知回调方法。
      onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
        print(message['extras']['kcmc']);
        print(message['extras']['jxcdmc']);
        print(message['extras']['qssj']);
        Dialogs.bottomMaterialDialog(
          color: Colors.white,
          msg: '课程名称：' +
              message['extras']['kcmc'] +
              '\n教学场地：' +
              message['extras']['jxcdmc'] +
              '\n上课时间：' +
              message['extras']['qssj'],
          title: '详细信息',
          lottieBuilder: Lottie.asset(
            'assets/course.json',
            fit: BoxFit.contain,
          ),
          context: HomePage().homecontext,
        );
      },
      // 接收自定义消息回调方法。
      onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
      },
    );
    jpush.setup(
      appKey: "c838ef67e8b74ab79c7e9c17",
      channel: "theChannel",
      production: false,
      debug: true, // 设置是否打印 debug 日志
    );
    jpush.getRegistrationID().then((rid) {
      print("通知id" + rid.toString());
      jpushs.rid = rid.toString();
    });
    uploadpushid();
  }

  void uploadpushid() {
    if (isIOS) {
      return;
    }
    //上传pushid
    Dio dio = new Dio();
    var url =
        'https://pushcourse-pushcourse-bvlnfogvvc.cn-hongkong.fcapp.run/insertpushid?pushid=' +
            rid.toString() +
            '&stuid=' +
            Global.jwc_xuehao;
    print(url);
    dio.get(url);
  }
}

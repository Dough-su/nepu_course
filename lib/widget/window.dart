import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:muse_nepu_course/global.dart';
import 'package:muse_nepu_course/windowsfloat.dart';

class windows {
  Widget getwindow(context) {
    //判断是否是windows
    if (Platform.isWindows)
      return Container(
        color: Global.home_currentcolor,
        child: WindowTitleBarBox(
          child: Row(
            children: [
              Expanded(child: MoveWindow()),
              Row(
                children: [
                  MinimizeWindowButton(colors: buttonColors),
                  RestoreWindowButton(
                    colors: buttonColors,
                    onPressed: () {
                      //跳转到windowfloat页面
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => windwosfloat(),
                        ),
                      );
                    },
                  ),
                  CloseWindowButton(colors: closeButtonColors),
                ],
              )
            ],
          ),
        ),
      );
    else
      return Container();
  }
}

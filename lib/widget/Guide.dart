import 'package:flutter/material.dart';
import 'package:muse_nepu_course/page/HomePage.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Guide {
  List<TargetFocus> targets = [
    TargetFocus(
        identify: "日期选择器",
        targetPosition: TargetPosition(Size(100, 100), Offset(330, 30)),
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "日期选择器",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "在这里不光可以快速跳转到对应日期，更可以快速回溯到以往学期。很赞吧",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ]),
    TargetFocus(identify: "成绩菜单", keyTarget: scoredetailbtn, contents: [
      TargetContent(
          align: ContentAlign.bottom,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "成绩菜单",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "可以轻松查看每科课程的排名，以及详细的平时成绩和考试成绩",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ))
    ]),
    TargetFocus(
        identify: "当前日期",
        targetPosition: TargetPosition(Size(100, 100), Offset(0, 100)),
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "课程日期",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "在这行左右滑动即可，快速查看附近日期的课程，平时也可以用来解压哦",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ]),
    TargetFocus(
        identify: "课表菜单",
        targetPosition: TargetPosition(Size(100, 100), Offset(0, 140)),
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "课表菜单",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "里面可以查看学习通考完但未发布的成绩，左右滑动就可以快速评教，可以调整当前页面主题色，包括在设置中调整logo以及头像，话不多说，来试试吧",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ])
  ];
}

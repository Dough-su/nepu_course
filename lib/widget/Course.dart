import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:timelines/timelines.dart';

import '../global.dart';
class Course{
 static Widget coursedetail(String time, int index, String msg, eventcahe,
      bool hasStartConnector, bool hasEndConnector,widthx,context) {
    return FadeInLeft(
        child: Container(
          child: TimelineTile(
            oppositeContents: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  width: widthx,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    time +
                        '\n' +
                        eventcahe[index]['qssj']
                            .toString()
                            .split(' ')[0]
                            .substring(0, 5) +
                        ' - ' +
                        eventcahe[index]['jssj']
                            .toString()
                            .split(' ')[0]
                            .substring(0, 5),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            contents: GestureDetector(
              onTap: (() => Dialogs.bottomMaterialDialog(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Color(0xFF1C1B1F),
                msg: msg,
                title: '详细信息',
                lottieBuilder: Lottie.asset(
                  'assets/course.json',
                  fit: BoxFit.contain,
                ),
                context: context,
              )),
              child: Card(
                color: Global.home_currentcolor,
                child: Container(
                  width: widthx,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    eventcahe[index]['kcmc'] + '\n' + eventcahe[index]['jxcdmc'],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            node: TimelineNode(
              indicator: DotIndicator(
                color: Global.home_currentcolor,
              ),
              startConnector: hasStartConnector
                  ? SolidLineConnector(
                color: Global.home_currentcolor,
              )
                  : null,
              endConnector: hasEndConnector
                  ? SolidLineConnector(
                color: Global.home_currentcolor,
              )
                  : null,
            ),
          ),
        ));
  }

}
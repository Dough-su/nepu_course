import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:muse_nepu_course/widget/qingjia_bottom_sheet.dart';
import 'package:timelines/timelines.dart';

import '../util/global.dart';
class Course {
  static Widget coursedetail(String time, int index, String msg, eventcahe,
      bool hasStartConnector, bool hasEndConnector, widthx, context) {
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
                actions: [
                  TextButton(
                    onPressed: () {
                      //关闭
                      Navigator.of(context).pop();
                      showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Color(0xFF1C1B1F),
                        elevation: 0,
                        useRootNavigator: true,
                        isScrollControlled: true,
                        builder: (context) => LayoutBuilder(
                          builder: (context, constraints) => Container(
                            child: PaymentBottomSheet(detail: eventcahe,index:index),
                          ),
                        ),
                      );
                    },
                    child: Text('为这节课请假'),
                  ),
                ],
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

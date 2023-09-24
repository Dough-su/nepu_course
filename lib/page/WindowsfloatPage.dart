import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:muse_nepu_course/util/global.dart';
import 'package:timelines/timelines.dart';
import 'package:window_manager/window_manager.dart';

class windwosfloat extends StatefulWidget {
  const windwosfloat({Key? key}) : super(key: key);

  @override
  _windwosfloatState createState() => _windwosfloatState();
}

String title = '今日课程';

var date;
var widthx;
List<Widget> dailycourse = [];

class _windwosfloatState extends State<windwosfloat> with WindowListener {
  ImageProvider logopic = AssetImage('images/logo.png');
  ImageProvider calendarlogo = AssetImage('images/logo.png');

  List<Container> dailycourse = [
    Container(
      color: //透明
          Colors.transparent,
      padding: EdgeInsets.only(left: 60, top: 30),
      child: Row(
        children: [
          Text(
            '上午',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Global.home_currentcolor),
          ),
        ],
      ),
    ),
    Container(
      child: TimelineTile(
        oppositeContents: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Container(
              width: widthx,
              padding: EdgeInsets.all(8.0),
              child: Text(
                '1,2节\n8:00 - 9:35',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        contents: Card(
          //透明
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          child: Container(
            width: widthx,
            padding: EdgeInsets.all(8.0),
            child: Text(
              '',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        node: TimelineNode(
          indicator: DotIndicator(
            color: Global.home_currentcolor,
          ),
          endConnector: SolidLineConnector(
            color: Global.home_currentcolor,
          ),
        ),
      ),
    ),
    Container(
      child: TimelineTile(
        oppositeContents: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Container(
              width: widthx,
              padding: EdgeInsets.all(8.0),
              child: Text(
                '3,4节\n9:55 -11:30',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        contents: Card(
          //透明
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          child: Container(
            width: widthx,
            padding: EdgeInsets.all(8.0),
            child: Text(
              '',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        node: TimelineNode(
          indicator: DotIndicator(
            color: Global.home_currentcolor,
          ),
          startConnector: SolidLineConnector(
            color: Global.home_currentcolor,
          ),
        ),
      ),
    ),
    Container(
      padding: EdgeInsets.only(left: 60, top: 30),
      child: Row(
        children: [
          Text(
            '下午',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Global.home_currentcolor),
          ),
        ],
      ),
    ),
    Container(
      child: TimelineTile(
        oppositeContents: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Container(
              width: widthx,
              padding: EdgeInsets.all(8.0),
              child: Text(
                '5,6节\n13;30 - 15:05',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        contents: Card(
          //透明
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          child: Container(
            width: widthx,
            padding: EdgeInsets.all(8.0),
            child: Text(
              '',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        node: TimelineNode(
          indicator: DotIndicator(
            color: Global.home_currentcolor,
          ),
          endConnector: SolidLineConnector(
            color: Global.home_currentcolor,
          ),
        ),
      ),
    ),
    Container(
      child: TimelineTile(
        oppositeContents: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Container(
              width: widthx,
              padding: EdgeInsets.all(8.0),
              child: Text(
                '7,8节\n15:25 - 17:00',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        contents: Card(
          shadowColor: Colors.transparent,
          //透明
          color: Colors.transparent,
          child: Container(
            width: widthx,
            padding: EdgeInsets.all(8.0),
            child: Text(
              '',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        node: TimelineNode(
          indicator: DotIndicator(
            color: Global.home_currentcolor,
          ),
          startConnector: SolidLineConnector(
            color: Global.home_currentcolor,
          ),
        ),
      ),
    ),
    Container(
      padding: EdgeInsets.only(left: 60, top: 30),
      child: Row(
        children: [
          Text(
            '晚课',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Global.home_currentcolor),
          ),
        ],
      ),
    ),
    Container(
      child: TimelineTile(
        oppositeContents: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Container(
              width: widthx,
              padding: EdgeInsets.all(8.0),
              child: Text(
                '9,10节\n18:00 - 19:35',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        contents: Card(
          //透明
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          child: Container(
            width: widthx,
            padding: EdgeInsets.all(8.0),
            child: Text(
              '',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        node: TimelineNode(
          indicator: DotIndicator(
            color: Global.home_currentcolor,
          ),
          endConnector: SolidLineConnector(
            color: Global.home_currentcolor,
          ),
        ),
      ),
    ),
    Container(
      child: TimelineTile(
        oppositeContents: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Container(
              width: widthx,
              padding: EdgeInsets.all(8.0),
              child: Text(
                '11,12节\n19:55 - 21:30',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        contents: Card(
          //透明
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          child: Container(
            width: widthx,
            padding: EdgeInsets.all(8.0),
            child: Text(
              '',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        node: TimelineNode(
          indicator: DotIndicator(
            color: Global.home_currentcolor,
          ),
          startConnector: SolidLineConnector(
            color: Global.home_currentcolor,
          ),
        ),
      ),
    ),
  ];
  loadwidget(DateTime date) {
    var eventcahe = [];

    var cacheindex = 0;
    var pos = 0;
    for (var i = 0; i < Global.courseInfox.length; i++) {
      //判断是否是今天的课程
      if (Global.courseInfox[i]['jsrq'] == date.toString().substring(0, 10)) {
        cacheindex++;
        eventcahe.add(Global.courseInfox[i]);
      }
      //如果读取之后的时间在今天之前则跳过
      if (Global.courseInfox[i]['jsrq']
              .compareTo(date.toString().substring(0, 10)) <
          0) {
        pos = i;
        break;
      }
    }

    //判断是否有课程
    if (cacheindex == 0) {
      dailycourse = [
        Container(
          padding: EdgeInsets.only(left: 60, top: 30),
          child: Row(
            children: [
              Text(
                '今天没课哦',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Global.home_currentcolor),
              ),
            ],
          ),
        ),
      ];
      // print('pos是' + pos.toString());
      // print(Global.courseInfox[pos]['zc']);
      // print(Global.courseInfox[pos]['jsrq']);
      // print(date.toString().substring(0, 10));
      //判断jsrq和date的日期差
      var date1 = DateTime.parse(Global.courseInfox[pos]['jsrq']);
      //获取date1的周日
      var date2 = date1.add(Duration(days: 7 - date1.weekday));
      var date3 = DateTime.parse(date2.toString().substring(0, 10));
      // print('上一个周日是' + date3.toString());
      //获取date的周一
      var date4 = date.add(Duration(days: 1 - date.weekday));
      // print('周一是' + date4.toString());
      var difference = date4.difference(date3).inDays;
      // print(difference);
      if (difference == 0) difference = 1;

      int zc = Global.courseInfox[pos]['zc'];
      if (difference > 0)
        zc = Global.courseInfox[pos]['zc'] + //向上取整
            ((difference / 7).ceil());
      if (difference < 28)
        title = '第' + zc.toString() + '周' + '当天没课哦';
      else
        title = '假期中。。。';
    } else {
      setState(() {
        title = '第' + eventcahe[0]['zc'].toString() + '周' + title;
        print('title是' + title);
      });
    }
    //对eventcahe进行排序
    eventcahe.sort((a, b) {
      return a['qssj'].toString().compareTo(b['qssj'].toString());
    });

    dailycourse = [
      Container(
        padding: EdgeInsets.only(left: 60, top: 30),
        child: Row(
          children: [
            Text(
              '上午',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Global.home_currentcolor),
            ),
          ],
        ),
      ),
      Container(
        child: TimelineTile(
          oppositeContents: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                width: widthx,
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '1,2节\n8:00 - 9:35',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          contents: Card(
            //透明
            color: Colors.transparent,
            shadowColor: Colors.transparent,
            child: Container(
              width: widthx,
              padding: EdgeInsets.all(8.0),
              child: Text(
                '',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          node: TimelineNode(
            indicator: DotIndicator(
              color: Global.home_currentcolor,
            ),
            endConnector: SolidLineConnector(
              color: Global.home_currentcolor,
            ),
          ),
        ),
      ),
      Container(
        child: TimelineTile(
          oppositeContents: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                width: widthx,
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '3,4节\n9:55 -11:30',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          contents: Card(
            //透明
            color: Colors.transparent,
            shadowColor: Colors.transparent,
            child: Container(
              width: widthx,
              padding: EdgeInsets.all(8.0),
              child: Text(
                '',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          node: TimelineNode(
            indicator: DotIndicator(
              color: Global.home_currentcolor,
            ),
            startConnector: SolidLineConnector(
              color: Global.home_currentcolor,
            ),
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.only(left: 60, top: 30),
        child: Row(
          children: [
            Text(
              '下午',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Global.home_currentcolor),
            ),
          ],
        ),
      ),
      Container(
        child: TimelineTile(
          oppositeContents: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                width: widthx,
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '5,6节\n13;30 - 15:05',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          contents: Card(
            //透明
            color: Colors.transparent,
            shadowColor: Colors.transparent,
            child: Container(
              width: widthx,
              padding: EdgeInsets.all(8.0),
              child: Text(
                '',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          node: TimelineNode(
            indicator: DotIndicator(
              color: Global.home_currentcolor,
            ),
            endConnector: SolidLineConnector(
              color: Global.home_currentcolor,
            ),
          ),
        ),
      ),
      Container(
        child: TimelineTile(
          oppositeContents: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                width: widthx,
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '7,8节\n15:25 - 17:00',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          contents: Card(
            shadowColor: Colors.transparent,
            //透明
            color: Colors.transparent,
            child: Container(
              width: widthx,
              padding: EdgeInsets.all(8.0),
              child: Text(
                '',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          node: TimelineNode(
            indicator: DotIndicator(
              color: Global.home_currentcolor,
            ),
            startConnector: SolidLineConnector(
              color: Global.home_currentcolor,
            ),
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.only(left: 60, top: 30),
        child: Row(
          children: [
            Text(
              '晚课',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Global.home_currentcolor),
            ),
          ],
        ),
      ),
      Container(
        child: TimelineTile(
          oppositeContents: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                width: widthx,
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '9,10节\n18:00 - 19:35',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          contents: Card(
            //透明
            color: Colors.transparent,
            shadowColor: Colors.transparent,
            child: Container(
              width: widthx,
              padding: EdgeInsets.all(8.0),
              child: Text(
                '',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          node: TimelineNode(
            indicator: DotIndicator(
              color: Global.home_currentcolor,
            ),
            endConnector: SolidLineConnector(
              color: Global.home_currentcolor,
            ),
          ),
        ),
      ),
      Container(
        child: TimelineTile(
          oppositeContents: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                width: widthx,
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '11,12节\n19:55 - 21:30',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          contents: Card(
            //透明
            color: Colors.transparent,
            shadowColor: Colors.transparent,
            child: Container(
              width: widthx,
              padding: EdgeInsets.all(8.0),
              child: Text(
                '',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          node: TimelineNode(
            indicator: DotIndicator(
              color: Global.home_currentcolor,
            ),
            startConnector: SolidLineConnector(
              color: Global.home_currentcolor,
            ),
          ),
        ),
      ),
    ];
    for (var i = 0; i < eventcahe.length; i++) {
      String msg = '课程名称:' +
          eventcahe[i]['kcmc'] +
          '\n' +
          '教室:' +
          eventcahe[i]['jxcdmc'] +
          '\n' +
          '第' +
          eventcahe[i]['zc'].toString() +
          '周课程' +
          '\n' +
          '教师:' +
          eventcahe[i]['teaxms'] +
          '\n' +
          '教学班级:' +
          eventcahe[i]['jxbmc'] +
          '\n' +
          '额外备注:' +
          eventcahe[i]['sknrjj'];
      //判断课程时间段，如果是08,替换dailycourse中第二个Container
      if (eventcahe[i]['qssj'].toString().split(' ')[0].substring(0, 2) ==
          '08') {
        //清空dailycourse

        dailycourse[1] = Container(
          child: TimelineTile(
            oppositeContents: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  width: widthx,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '1,2节\n' +
                        eventcahe[i]['qssj']
                            .toString()
                            .split(' ')[0]
                            .substring(0, 5) +
                        ' - ' +
                        eventcahe[i]['jssj']
                            .toString()
                            .split(' ')[0]
                            .substring(0, 5),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            contents:
                //ontap
                GestureDetector(
              onTap: (() => Dialogs.bottomMaterialDialog(
                    color: Colors.white,
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
                    eventcahe[i]['kcmc'] + '\n' + eventcahe[i]['jxcdmc'],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            node: TimelineNode(
              indicator: DotIndicator(
                color: Global.home_currentcolor,
              ),
              endConnector: SolidLineConnector(
                color: Global.home_currentcolor,
              ),
            ),
          ),
        );
      }
      //判断课程时间段，如果是09,替换dailycourse中第三个Container
      if (eventcahe[i]['qssj'].toString().split(' ')[0].substring(0, 2) ==
          '09') {
        dailycourse[2] = Container(
          child: TimelineTile(
            oppositeContents: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  width: widthx,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '3,4节\n' +
                        eventcahe[i]['qssj']
                            .toString()
                            .split(' ')[0]
                            .substring(0, 5) +
                        ' - ' +
                        eventcahe[i]['jssj']
                            .toString()
                            .split(' ')[0]
                            .substring(0, 5),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            contents: //ontap
                GestureDetector(
              onTap: (() => Dialogs.bottomMaterialDialog(
                    color: Colors.white,
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
                    eventcahe[i]['kcmc'] + '\n' + eventcahe[i]['jxcdmc'],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            node: TimelineNode(
              indicator: DotIndicator(
                color: Global.home_currentcolor,
              ),
              startConnector: SolidLineConnector(
                color: Global.home_currentcolor,
              ),
            ),
          ),
        );
      }
      //判断课程时间段，如果jssj是11,替换dailycourse中第三个Container
      if (eventcahe[i]['jssj'].toString().split(' ')[0].substring(0, 2) ==
          '11') {
        dailycourse[2] = Container(
          child: TimelineTile(
            oppositeContents: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  width: widthx,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '3,4节\n' +
                        eventcahe[i]['qssj']
                            .toString()
                            .split(' ')[0]
                            .substring(0, 5) +
                        ' - ' +
                        eventcahe[i]['jssj']
                            .toString()
                            .split(' ')[0]
                            .substring(0, 5),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            contents: //ontap
                GestureDetector(
              onTap: (() => Dialogs.bottomMaterialDialog(
                    color: Colors.white,
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
                    eventcahe[i]['kcmc'] + '\n' + eventcahe[i]['jxcdmc'],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            node: TimelineNode(
              indicator: DotIndicator(
                color: Global.home_currentcolor,
              ),
              startConnector: SolidLineConnector(
                color: Global.home_currentcolor,
              ),
            ),
          ),
        );
      }
      //判断课程时间段，如果qssj是13,替换dailycourse中第五个Container
      if (eventcahe[i]['qssj'].toString().split(' ')[0].substring(0, 2) ==
          '13') {
        dailycourse[4] = Container(
          child: TimelineTile(
            oppositeContents: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  width: widthx,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '5,6节\n' +
                        eventcahe[i]['qssj']
                            .toString()
                            .split(' ')[0]
                            .substring(0, 5) +
                        ' - ' +
                        eventcahe[i]['jssj']
                            .toString()
                            .split(' ')[0]
                            .substring(0, 5),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            contents: //ontap
                GestureDetector(
              onTap: (() => Dialogs.bottomMaterialDialog(
                    color: Colors.white,
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
                    eventcahe[i]['kcmc'] + '\n' + eventcahe[i]['jxcdmc'],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            node: TimelineNode(
              indicator: DotIndicator(
                color: Global.home_currentcolor,
              ),
              endConnector: SolidLineConnector(
                color: Global.home_currentcolor,
              ),
            ),
          ),
        );
      }
      //判断课程时间段，如果jssj是17,替换dailycourse中第六个Container
      if (eventcahe[i]['jssj'].toString().split(' ')[0].substring(0, 2) ==
          '17') {
        dailycourse[5] = Container(
          child: TimelineTile(
            oppositeContents: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  width: widthx,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '7,8节\n' +
                        eventcahe[i]['qssj']
                            .toString()
                            .split(' ')[0]
                            .substring(0, 5) +
                        ' - ' +
                        eventcahe[i]['jssj']
                            .toString()
                            .split(' ')[0]
                            .substring(0, 5),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            contents: //ontap
                GestureDetector(
              onTap: (() => Dialogs.bottomMaterialDialog(
                    color: Colors.white,
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
                    eventcahe[i]['kcmc'] + '\n' + eventcahe[i]['jxcdmc'],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            node: TimelineNode(
              indicator: DotIndicator(
                color: Global.home_currentcolor,
              ),
              startConnector: SolidLineConnector(
                color: Global.home_currentcolor,
              ),
            ),
          ),
        );
      }
      //判断课程时间段，如果qssj是15,替换dailycourse中第六个Container
      if (eventcahe[i]['qssj'].toString().split(' ')[0].substring(0, 2) ==
          '15') {
        dailycourse[5] = Container(
          child: TimelineTile(
            oppositeContents: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  width: widthx,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '7,8节\n' +
                        eventcahe[i]['qssj']
                            .toString()
                            .split(' ')[0]
                            .substring(0, 5) +
                        ' - ' +
                        eventcahe[i]['jssj']
                            .toString()
                            .split(' ')[0]
                            .substring(0, 5),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            contents: //ontap
                GestureDetector(
              onTap: (() => Dialogs.bottomMaterialDialog(
                    color: Colors.white,
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
                    eventcahe[i]['kcmc'] + '\n' + eventcahe[i]['jxcdmc'],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            node: TimelineNode(
              indicator: DotIndicator(
                color: Global.home_currentcolor,
              ),
              startConnector: SolidLineConnector(
                color: Global.home_currentcolor,
              ),
            ),
          ),
        );
      }
      //判断课程时间段，如果qssj是18,替换dailycourse中第七个Container
      if (eventcahe[i]['qssj'].toString().split(' ')[0].substring(0, 2) ==
          '18') {
        dailycourse[7] = Container(
          child: TimelineTile(
            oppositeContents: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  width: widthx,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '9,10节\n' +
                        eventcahe[i]['qssj']
                            .toString()
                            .split(' ')[0]
                            .substring(0, 5) +
                        ' - ' +
                        eventcahe[i]['jssj']
                            .toString()
                            .split(' ')[0]
                            .substring(0, 5),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            contents: //ontap
                GestureDetector(
              onTap: (() => Dialogs.bottomMaterialDialog(
                    color: Colors.white,
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
                    eventcahe[i]['kcmc'] + '\n' + eventcahe[i]['jxcdmc'],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            node: TimelineNode(
              indicator: DotIndicator(
                color: Global.home_currentcolor,
              ),
              endConnector: SolidLineConnector(
                color: Global.home_currentcolor,
              ),
            ),
          ),
        );
      }
      //判断课程时间段，如果jssj是21,替换dailycourse中第八个Container
      if (eventcahe[i]['jssj'].toString().split(' ')[0].substring(0, 2) ==
          '21') {
        dailycourse[8] = Container(
          child: TimelineTile(
            oppositeContents: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  width: widthx,
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '9,10节\n' +
                        eventcahe[i]['qssj']
                            .toString()
                            .split(' ')[0]
                            .substring(0, 5) +
                        ' - ' +
                        eventcahe[i]['jssj']
                            .toString()
                            .split(' ')[0]
                            .substring(0, 5),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            contents: //ontap
                GestureDetector(
              onTap: (() => Dialogs.bottomMaterialDialog(
                    color: Colors.white,
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
                    eventcahe[i]['kcmc'] + '\n' + eventcahe[i]['jxcdmc'],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            node: TimelineNode(
              indicator: DotIndicator(
                color: Global.home_currentcolor,
              ),
              startConnector: SolidLineConnector(
                color: Global.home_currentcolor,
              ),
            ),
          ),
        );
      }
    }
    setState(() {});
  }

//刷新items
  hItems(DateTime date) async {
    await Global().loadItems(date);
    loadwidget(date);
    print('刷新items');
  }

  void initState() {
    hItems(DateTime.now());

    super.initState();
    windowManager
        .setPosition(Offset(Global.desktopx, Global.desktopy)); //设置窗口位置
    windowManager
        .setSize(Size(Global.desktopwidth, Global.desktopheight)); //设置窗口大小
    //初始化
    windowManager.addListener(this);
    WindowOptions windowOptions = WindowOptions(
      backgroundColor: Colors.transparent, //背景色
      skipTaskbar: false, //是否在任务栏显示
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      // await windowManager.focus();
      // await windowManager.setAlwaysOnBottom(true);
    });
  }

  @override
  void onWindowResized() {
    windowManager.getSize().then((value) {
      setState(() {
        Global.desktopheight = value.height;
        Global.desktopwidth = value.width;
        Global.savedesktopinfo();
      });
    });
  }

  @override
  void onWindowMoved() {
    windowManager.getPosition().then((value) {
      Global.desktopx = value.dx; //dx是x坐标
      Global.desktopy = value.dy;
      Global.savedesktopinfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    widthx = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: [
          Container(
            child: WindowTitleBarBox(
              child: Row(
                children: [
                  Expanded(child: MoveWindow()),
                  Row(
                    children: [
                      //加一个按钮

                      MinimizeWindowButton(colors: buttonColors),
                      RestoreWindowButton(
                        colors: buttonColors,
                        onPressed: () {
                          appWindow.alignment = Alignment.center;
                          const initialSize = Size(900, 800);
                          appWindow.size = initialSize;

                          //跳转到主页
                          Navigator.pop(context);
                        },
                      ),

                      CloseWindowButton(colors: closeButtonColors),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              //padding靠左
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: ListView(
                  children: dailycourse,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final buttonColors = WindowButtonColors(
    iconNormal: const Color(0xFF805306),
    mouseOver: const Color(0xFFF6A00C),
    mouseDown: const Color(0xFF805306),
    iconMouseOver: const Color(0xFF805306),
    iconMouseDown: const Color(0xFFFFD500));

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFF805306),
    iconMouseOver: Colors.white);

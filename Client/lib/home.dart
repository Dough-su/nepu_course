import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:dynamic_timeline/dynamic_timeline.dart';
import 'package:intl/intl.dart';
import 'about.dart';
import 'course.dart';
import 'coursemenu/scoredetail.dart';
import 'event.dart';
import 'dart:io';
import 'package:m_toast/m_toast.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notificationUtils.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

DateTime get _now => DateTime.now();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

String title = '今日课程';
Color pickerColor = Color.fromARGB(255, 73, 160, 230);
Color currentColor = Color.fromARGB(255, 73, 160, 230);

class _HomePageState extends State<HomePage> {
  ShowMToast toast = ShowMToast();
  bool isdownload = true;
  @override
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  //读取登录信息
  Future<String> getLoginInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? JSESSIONID = '?JSESSIONID=' +
        sharedPreferences.getString('JSESSIONID')!; //获取JSESSIONID
    String? webvpn_key = '&_webvpn_key=' +
        sharedPreferences.getString('webvpn_key')!; //获取webvpn_key
    String? webvpn_username = '&webvpn_username=' +
        sharedPreferences.getString('webvpn_username')!; //获取webvpn_username
    //获取savedPassword
    String? savedPassword = sharedPreferences.getString('savedPassword');
    //获取savedEmail
    String? savedEmail = sharedPreferences.getString('savedEmail');

    print('JSESSIONID: $JSESSIONID');
    print('webvpn_key: $webvpn_key');
    print('webvpn_username: $webvpn_username');
    print('savedPassword: $savedPassword');
    print('savedEmail: $savedEmail');
    return JSESSIONID + webvpn_key + webvpn_username;
  }

  DateTime _selectedIndex = DateTime.now();
  CalendarAgendaController _calendarAgendaControllerAppBar =
      CalendarAgendaController();
  @override
  Future<void> getcolor() async {
    getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/color.txt');
      if (file.existsSync()) {
        file.readAsString().then((value) {
          setState(() {
            currentColor = Color(int.parse(value));
            pickerColor = Color(int.parse(value));
          });
        });
      }
    });
    setState(() {});
  }

  void initState() {
    getcolor();
    //getApplicationDocumentsDirectory()方法获取应用程序的文档目录
    getApplicationDocumentsDirectory().then((value) {
      notification.init();
      int count = 0;
      const period = const Duration(minutes: 10);
      Timer.periodic(period, (timer) {
        //到时回调
        checkCourse();
        count++;
      });

      File file = new File(value.path + '/course.json');
      file.exists().then((value) {
        if (!value) {
          //没有则下载
          downApkFunction();
        } else {
          //有则读取
          hItems(DateTime.now());
        }
      });
    });
  }

  void deleteFile() {
    getApplicationDocumentsDirectory().then((value) {
      File file = new File(value.path + '/course.json');
      if (file.existsSync()) {
        file.deleteSync();
      }
    });
  }

//读取下载的json
  Future<String> getCourseInfo() async {
    //获取路径
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/course.json';
    //读取文件
    File file = new File(path);
    String courseInfo = await file.readAsString();
    return courseInfo;
  }

  //检测15分钟后是否有课
  //如果有则发送通知
  void checkCourse() async {
    //获取路径
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/course.json';
    //读取文件
    File file = new File(path);
    String courseInfo = await file.readAsString();
    var course = json.decode(courseInfo);
    //获取当前时间
    DateTime now = DateTime.now();
    //获取当前时间的15分钟后的时间
    DateTime after15 = now.add(Duration(minutes: 15));
    print('15分后' + after15.toString().substring(11, 16) + ':00');

    //获取json中的课程信息
    for (var i = 0; i < course.length; i++) {
      if (course[i]['jsrq'] ==
          now.year.toString() +
              '-' +
              now.month.toString() +
              '-' +
              now.day.toString()) {
        print('获取到的时间' + course[i]['qssj']);
        if (course[i]['qssj']
                .compareTo(after15.toString().substring(11, 16) + ':00') <
            0) {
          Map params = {};
          params['type'] = 200;
          params['id'] = "10086";
          params['content'] = "你有一门课程即将开始";
          notification.send(
              '你的' +
                  course[i]['kcmc'] +
                  '在' +
                  course[i]['qssj'].toString() +
                  '开始',
              '你的' +
                  course[i]['kcmc'] +
                  '在' +
                  course[i]['qssj'].toString() +
                  '开始',
              params: json.encode(params));
          break;
        }
      }
    }
  }

  void downApkFunction() async {
    print('开始下载');
    var dio = Dio();
    //下载课程
    var url =
        'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/course' +
            await getLoginInfo();
    getApplicationDocumentsDirectory().then((value) {
      //如果下载json完成则读取
      dio.download(url, value.path + '/course.json').then((value) async {
        //下载成绩
        isdownload = false;
        var urlscore =
            'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/getscore' +
                await getLoginInfo();
        getApplicationDocumentsDirectory().then((value) {
          dio.download(urlscore, value.path + '/score.json').then((value) {
            isdownload = true;
          });
        });
        //下载完成后调用hitems
        hItems(DateTime.now());
      });
    });
  }

  final items = [
    TimelineItem(
      startDateTime: DateTime(1973, 1, 1, 8, 30),
      endDateTime: DateTime(1973, 1, 1, 9, 55),
      child: const Event(title: '占位课程'),
    ),
  ];

  loadItems(DateTime date) async {
    items.clear();

    getCourseInfo().then((value) async {
      print("输出应该" + value);
      var courseInfo = json.decode(value);

      for (var i = 0; i < courseInfo.length; i++) {
        //判断是否是今天的课程
        if (courseInfo[i]['jsrq'] == date.toString().substring(0, 10)) {
          //获取课程开始时间
          var startDateTime = DateTime(
              1971,
              1,
              1,
              int.parse(courseInfo[i]['qssj'].toString().substring(0, 2)),
              int.parse(courseInfo[i]['qssj'].toString().substring(3, 5)));
          //获取课程结束时间
          var endDateTime = DateTime(
              1971,
              1,
              1,
              int.parse(courseInfo[i]['jssj'].toString().substring(0, 2)),
              int.parse(courseInfo[i]['jssj'].toString().substring(3, 5)));
          //如果date不是今天则修改title为非本日课程
          if (date.toString().substring(0, 10) !=
              DateTime.now().toString().substring(0, 10)) {
            title = '非本日课程';
          } else {
            title = '今日课程';
          }

          //添加课程
          items.add(TimelineItem(
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            child: Event(
                title: '课程名称：' +
                    courseInfo[i]['kcmc'] +
                    '\n' +
                    '教师姓名：' +
                    courseInfo[i]['teaxms'] +
                    '\n' +
                    '教室名称：' +
                    courseInfo[i]['jxcdmc'] +
                    '\n' +
                    '上课班级：' +
                    courseInfo[i]['jxbmc'] +
                    '\n'),
          ));
        }
      }
      setState(() {});
    });
  }

//刷新items
  hItems(DateTime date) async {
    if (loadItems(date) == "success") {
      print('loadItems刷新成功');
    }
  }

  List<TimelineItem> returnitems() {
    print('调用我了');
    return items;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CalendarAgenda(
          controller: _calendarAgendaControllerAppBar,
          initialDate: DateTime.now(),
          appbar: true,
          backgroundColor: currentColor,
          firstDate: DateTime.now().subtract(Duration(days: 1400)),
          lastDate: DateTime.now().add(Duration(days: 365)),
          locale: 'zh_CN',
          selectedDateColor: Colors.green.shade900,
          fullCalendarScroll: FullCalendarScroll.vertical,
          fullCalendarDay: WeekDay.long,
          dateColor: Colors.white,
          calendarEventColor: currentColor,
          events: [DateTime.now().subtract(Duration(days: 0))],
          onDateSelected: (date) {
            print(date);
            hItems(date);
          },
        ),
        body: Scaffold(
          appBar: AppBar(
            backgroundColor: currentColor,
            title: Text(title),
            actions: [
              //加入回到今天文字和按钮
              TextButton(
                onPressed: () {
                  hItems(DateTime.now());
                  setState(() {
                    print('回到今天');
                    _calendarAgendaControllerAppBar.goToDay(DateTime.now());
                  });
                },
                child: Text(
                  '回到今天',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              //调色盘按钮
              IconButton(
                icon: Icon(Icons.color_lens),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('选择当前页颜色'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: currentColor,
                              onColorChanged: changeColor,
                              colorPickerWidth: 300.0,
                              pickerAreaHeightPercent: 0.7,
                              enableAlpha: false,
                              displayThumbColor: true,
                              showLabel: true,
                              paletteType: PaletteType.hsv,
                              pickerAreaBorderRadius: const BorderRadius.only(
                                topLeft: const Radius.circular(2.0),
                                topRight: const Radius.circular(2.0),
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('确定'),
                              onPressed: () async {
                                setState(() => currentColor = pickerColor);
                                getApplicationDocumentsDirectory()
                                    .then((value) {
                                  File file = File(value.path + '/color.txt');
                                  //判断文件是否存在
                                  if (file.existsSync()) {
                                    //存在则写入
                                    file.writeAsString(
                                        currentColor.value.toString());
                                  } else {
                                    //不存在则创建文件并写入
                                    file.createSync();
                                    file.writeAsString(
                                        currentColor.value.toString());
                                  }
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                },
              ),
              IconButton(
                icon: Icon(Icons.score),
                onPressed: () {
                  if (isdownload) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => score()),
                    );
                  } else {
                    toast.successToast(context,
                        message: "目前你的成绩数据没有下载完成，请等待30s",
                        alignment: Alignment.center);
                  }
                },
              ),
              //添加关于
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => about()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  deleteFile();
                },
              ),
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(40),
                child: DynamicTimeline(
                  color: currentColor,
                  firstDateTime: DateTime(1971, 1, 1, 8, 0),
                  lastDateTime: DateTime(1971, 1, 1, 21, 30),
                  labelBuilder: DateFormat('HH:mm').format,
                  intervalDuration: const Duration(hours: 2),
                  maxCrossAxisItemExtent: 250,
                  intervalExtent: 130,
                  minItemDuration: const Duration(minutes: 30),
                  items: returnitems(),
                )),
          ),
        ));
  }
}

course _$courseFromJson(Map<String, dynamic> json) {
  return course(
    kcmc: json['kcmc'] as String,
    jxcdmc: json['jxcdmc'] as String,
    teaxms: json['teaxms'] as String,
    xq: json['xq'] as int,
    zc: json['zc'] as int,
    jxbmc: json['jxbmc'] as String,
    sknrjj: json['sknrjj'] as String,
    qssj: json['qssj'] as String,
    jssj: json['jssj'] as String,
  );
}

Map<String, dynamic> _$courseToJson(course instance) => <String, dynamic>{
      'kcmc': instance.kcmc,
      'jxcdmc': instance.jxcdmc,
      'teaxms': instance.teaxms,
      'xq': instance.xq,
      'zc': instance.zc,
      'jxbmc': instance.jxbmc,
      'sknrjj': instance.sknrjj,
      'qssj': instance.qssj,
      'jssj': instance.jssj,
    };

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
import 'event.dart';
import 'dart:io';
import 'package:m_toast/m_toast.dart';

DateTime get _now => DateTime.now();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

String title = '今日课程';

class _HomePageState extends State<HomePage> {
  ShowMToast toast = ShowMToast();

  @override

  //读取登录信息
  Future<String> getLoginInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? JSESSIONID = '?JSESSIONID=' +
        sharedPreferences.getString('JSESSIONID')!; //获取JSESSIONID
    String? webvpn_key = '&_webvpn_key=' +
        sharedPreferences.getString('webvpn_key')!; //获取webvpn_key
    String? webvpn_username = '&webvpn_username=' +
        sharedPreferences.getString('webvpn_username')!; //获取webvpn_username
    print('JSESSIONID: $JSESSIONID');
    print('webvpn_key: $webvpn_key');
    print('webvpn_username: $webvpn_username');
    return JSESSIONID + webvpn_key + webvpn_username;
  }

  DateTime _selectedIndex = DateTime.now();

  @override
  void initState() {
    //getApplicationDocumentsDirectory()方法获取应用程序的文档目录
    getApplicationDocumentsDirectory().then((value) {
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

  void downApkFunction() async {
    print('开始下载');
    var dio = Dio();
    var url =
        'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/course' +
            await getLoginInfo();
    getApplicationDocumentsDirectory().then((value) {
      //如果下载json完成则读取
      dio.download(url, value.path + '/course.json').then((value) {
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
          initialDate: DateTime.now(),
          appbar: true,
          firstDate: DateTime.now().subtract(Duration(days: 900)),
          lastDate: DateTime.now().add(Duration(days: 365)),
          locale: 'zh_CN',
          onDateSelected: (date) {
            print(date);
            hItems(date);
          },
        ),
        body: Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: [
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

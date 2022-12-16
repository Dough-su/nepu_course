import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:shirne_dialog/shirne_dialog.dart';
import 'package:timelines/timelines.dart';
import 'about.dart';
import 'course.dart';
import 'coursemenu/scoredetail.dart';
import 'dart:io';
import 'package:m_toast/m_toast.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

DateTime get _now => DateTime.now();
List<Widget> dailycourse = [];

String title = '今日课程';
Color pickerColor = Color.fromARGB(255, 73, 160, 230);
Color currentColor = Color.fromARGB(255, 73, 160, 230);
var date;
var widthx;
ImageProvider logopic = AssetImage('images/logo.png');
ImageProvider calendarlogo = AssetImage('images/logo.png');

class TimelineDots {
  TimelineDots({required this.context});

  BuildContext context;

  factory TimelineDots.of(BuildContext context) {
    return TimelineDots(context: context);
  }

  Widget get sectionHighlighted {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        image: null,
        shape: BoxShape.circle,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ShowMToast toast = ShowMToast();
  bool isdownload = true;
  bool isDarkModeEnabled = false;

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

    print('JSESSIONID: $JSESSIONID');
    print('webvpn_key: $webvpn_key');
    print('webvpn_username: $webvpn_username');
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
    //下载课程
    var url =
        'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/course' +
            await getLoginInfo();
    getApplicationDocumentsDirectory().then((value) async {
      isdownload = false;

      //判断响应状态
      Response response = await dio.get(url);
      if (response.statusCode == 500) {
        MyDialog.alert(
          '登录出错了，密码错了，或者验证码，或者其他，反正就是错了，按下刷新键，重登录吧',
          buttonText: '好',
        );
      } else if (response.statusCode == 200) {
        //下载成功
        //获取路径
        Directory directory = await getApplicationDocumentsDirectory();
        String path = directory.path + '/course.json';
        //写入文件
        File file = new File(path);
        file.writeAsString(response.data);

        hItems(DateTime.now());
        setState(() {
          title = '下载成绩中';
        });

        final controller = MyDialog.loading(
          '下载成绩中，不是卡住了，别退好吗',
          showProgress: true,
          duration: Duration.zero,
        );
        Timer.periodic(const Duration(milliseconds: 1000), (timer) {
          controller.value += 0.02;

          if (controller.value >= 1) {
            timer.cancel();
          }
        });
        var urlscore =
            'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/getscore' +
                await getLoginInfo();

        getApplicationDocumentsDirectory().then((value) {
          //获取下载进度并将进度设置为标题
          dio.download(urlscore, value.path + '/score.json',
              onReceiveProgress: (int count, int total) {
            // controller.value += 0.2;
            controller.value = count / total;
            setState(() {});
          }).then((value) async {
            //下载完成
            isdownload = true;
            setState(() {
              title = '成绩下载完成';
            });
          });
        });
      }
      //下载完成后调用hitems
    });
  }

  loadItems(DateTime date) async {
    //打印调用次数
    print('loadItems');
    var eventcahe = [];
    getCourseInfo().then((value) async {
      if (value.contains('\u83b7\u53d6\u8bfe\u7a0b\u4fe1\u606f\u5931\u8d25')) {
        setState(() {
          title = '登录错误';
        });
        toast.successToast(context,
            message: "密码或验证码错了，请重新确认后输入", alignment: Alignment.center);
        deleteFile();
      }
      var courseInfo = json.decode(value);

      for (var i = 0; i < courseInfo.length; i++) {
        //判断是否是今天的课程
        if (courseInfo[i]['jsrq'] == date.toString().substring(0, 10)) {
          //如果date不是今天则修改title为非本日课程
          if (date.toString().substring(0, 10) !=
              DateTime.now().toString().substring(0, 10)) {
            title = '非本日课程';
          } else {
            title = '今日课程';
          }
          eventcahe.add(courseInfo[i]);
        }
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
                    color: currentColor),
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
                    '1,2节\n8;00 - 9:35',
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
                color: currentColor,
              ),
              endConnector: SolidLineConnector(
                color: currentColor,
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
                color: currentColor,
              ),
              startConnector: SolidLineConnector(
                color: currentColor,
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
                    color: currentColor),
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
                color: currentColor,
              ),
              endConnector: SolidLineConnector(
                color: currentColor,
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
                color: currentColor,
              ),
              startConnector: SolidLineConnector(
                color: currentColor,
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
                    color: currentColor),
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
                color: currentColor,
              ),
              endConnector: SolidLineConnector(
                color: currentColor,
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
                color: currentColor,
              ),
              startConnector: SolidLineConnector(
                color: currentColor,
              ),
            ),
          ),
        ),
      ];
      for (var i = 0; i < eventcahe.length; i++) {
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
                onTap: (() => MyDialog.popup(
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        Text(
                          eventcahe[i]['kcmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          eventcahe[i]['jxcdmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '第' + eventcahe[i]['zc'].toString() + '周课程',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '教师:' + eventcahe[i]['teaxms'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        //教学班级
                        Text(
                          '教学班级:' + eventcahe[i]['jxbmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '额外备注:' + eventcahe[i]['sknrjj'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ]),
                    )),
                child: Card(
                  color: currentColor,
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
                  color: currentColor,
                ),
                endConnector: SolidLineConnector(
                  color: currentColor,
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
                onTap: (() => MyDialog.popup(
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        Text(
                          eventcahe[i]['kcmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          eventcahe[i]['jxcdmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '第' + eventcahe[i]['zc'].toString() + '周课程',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '教师:' + eventcahe[i]['teaxms'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        //教学班级
                        Text(
                          '教学班级:' + eventcahe[i]['jxbmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '额外备注:' + eventcahe[i]['sknrjj'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ]),
                    )),
                child: Card(
                  color: currentColor,
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
                  color: currentColor,
                ),
                startConnector: SolidLineConnector(
                  color: currentColor,
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
                onTap: (() => MyDialog.popup(
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        Text(
                          eventcahe[i]['kcmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          eventcahe[i]['jxcdmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '第' + eventcahe[i]['zc'].toString() + '周课程',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '教师:' + eventcahe[i]['teaxms'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        //教学班级
                        Text(
                          '教学班级:' + eventcahe[i]['jxbmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '额外备注:' + eventcahe[i]['sknrjj'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ]),
                    )),
                child: Card(
                  color: currentColor,
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
                  color: currentColor,
                ),
                startConnector: SolidLineConnector(
                  color: currentColor,
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
                onTap: (() => MyDialog.popup(
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        Text(
                          eventcahe[i]['kcmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          eventcahe[i]['jxcdmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '第' + eventcahe[i]['zc'].toString() + '周课程',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '教师:' + eventcahe[i]['teaxms'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        //教学班级
                        Text(
                          '教学班级:' + eventcahe[i]['jxbmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '额外备注:' + eventcahe[i]['sknrjj'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ]),
                    )),
                child: Card(
                  color: currentColor,
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
                  color: currentColor,
                ),
                endConnector: SolidLineConnector(
                  color: currentColor,
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
                onTap: (() => MyDialog.popup(
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        Text(
                          eventcahe[i]['kcmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          eventcahe[i]['jxcdmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '第' + eventcahe[i]['zc'].toString() + '周课程',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '教师:' + eventcahe[i]['teaxms'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        //教学班级
                        Text(
                          '教学班级:' + eventcahe[i]['jxbmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '额外备注:' + eventcahe[i]['sknrjj'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ]),
                    )),
                child: Card(
                  color: currentColor,
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
                  color: currentColor,
                ),
                startConnector: SolidLineConnector(
                  color: currentColor,
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
                onTap: (() => MyDialog.popup(
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        Text(
                          eventcahe[i]['kcmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          eventcahe[i]['jxcdmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '第' + eventcahe[i]['zc'].toString() + '周课程',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '教师:' + eventcahe[i]['teaxms'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        //教学班级
                        Text(
                          '教学班级:' + eventcahe[i]['jxbmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '额外备注:' + eventcahe[i]['sknrjj'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ]),
                    )),
                child: Card(
                  color: currentColor,
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
                  color: currentColor,
                ),
                startConnector: SolidLineConnector(
                  color: currentColor,
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
                onTap: (() => MyDialog.popup(
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        Text(
                          eventcahe[i]['kcmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          eventcahe[i]['jxcdmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '第' + eventcahe[i]['zc'].toString() + '周课程',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '教师:' + eventcahe[i]['teaxms'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        //教学班级
                        Text(
                          '教学班级:' + eventcahe[i]['jxbmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '额外备注:' + eventcahe[i]['sknrjj'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ]),
                    )),
                child: Card(
                  color: currentColor,
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
                  color: currentColor,
                ),
                endConnector: SolidLineConnector(
                  color: currentColor,
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
                onTap: (() => MyDialog.popup(
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        Text(
                          eventcahe[i]['kcmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          eventcahe[i]['jxcdmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '第' + eventcahe[i]['zc'].toString() + '周课程',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '教师:' + eventcahe[i]['teaxms'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        //教学班级
                        Text(
                          '教学班级:' + eventcahe[i]['jxbmc'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '额外备注:' + eventcahe[i]['sknrjj'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ]),
                    )),
                child: Card(
                  color: currentColor,
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
                  color: currentColor,
                ),
                startConnector: SolidLineConnector(
                  color: currentColor,
                ),
              ),
            ),
          );
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

  Widget build(BuildContext context) {
    widthx = MediaQuery.of(context).size.width;

    return MaterialApp(
        navigatorKey: MyDialog.navigatorKey,
        localizationsDelegates: [
          ShirneDialogLocalizations.delegate,
        ],
        theme:
            ThemeData.light().copyWith(extensions: [const ShirneDialogTheme()]),
        darkTheme: ThemeData.dark(),
        home: Scaffold(
          appBar: CalendarAgenda(
            controller: _calendarAgendaControllerAppBar,
            initialDate: DateTime.now(),
            appbar: true,
            calendarLogo: getcalanderlogopngx(),
            selectedDayLogo:
                getlogopngx(), //使用ImageProvider<Object>加载IMage类型的logopic
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
                            return MaterialApp(
                                theme: ThemeData.light(),
                                darkTheme: ThemeData.dark(),
                                home: AlertDialog(
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
                                      pickerAreaBorderRadius:
                                          const BorderRadius.only(
                                        topLeft: const Radius.circular(2.0),
                                        topRight: const Radius.circular(2.0),
                                      ),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('确定'),
                                      onPressed: () async {
                                        setState(
                                            () => currentColor = pickerColor);
                                        getApplicationDocumentsDirectory()
                                            .then((value) {
                                          File file =
                                              File(value.path + '/color.txt');
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
                                ));
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
                      toast.successToast(context,
                          message: "已清除课程和成绩缓存，请退出app重新登录",
                          alignment: Alignment.center);
                    },
                  ),
                ],
              ),
              body: Container(
                  //padding靠左
                  child: ListView(
                children: dailycourse,
              ))),
        ));
  }

  ImageProvider<Object> getlogopngx() {
    getlogopng();
    return logopic;
  }

  getlogopng() async {
    //获取应用目录的logo.png，如果有则返回
    await getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/logo.png');
      if (file.existsSync()) {
        //将本地图片保存到logopic
        //将file转换为image
        print(file.path);
        logopic = Image.file(File(file.path)).image;
      }
    });
  }
}

Widget getcalanderlogopngx() {
  calanderlogo();
  //返回组件的ImageProvider<Object>类型
  return Container(
    child: Image(
      image: calendarlogo,
    ),
  );
}

calanderlogo() async {
  //获取应用目录的logo.png，如果有则返回
  await getApplicationDocumentsDirectory().then((value) {
    File file = File(value.path + '/calendar.png');
    if (file.existsSync()) {
      print(file.path);
      calendarlogo = Image.file(File(file.path)).image;
    }
  });
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

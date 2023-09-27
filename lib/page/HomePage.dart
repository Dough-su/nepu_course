import 'dart:async';
import 'dart:math';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muse_nepu_course/util/jpushs.dart';
import 'package:muse_nepu_course/util/global.dart';
import 'package:muse_nepu_course/service/api_service.dart';
import 'package:muse_nepu_course/widget/Course.dart';
import 'package:muse_nepu_course/widget/SideMenuBar.dart';
import 'package:muse_nepu_course/page/WindowsfloatPage.dart';
import 'package:rive/rive.dart';

import 'package:path_provider/path_provider.dart';
import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:timelines/timelines.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'dart:io';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:achievement_view/achievement_view.dart';

List<Widget> dailycourse = [];
List<Widget> dailycourse2 = [];
GlobalKey scoredetailbtn = GlobalKey();
GlobalKey scoredetailbtn2 = GlobalKey();

//上滑控制器
BottomSheetBarController bottomSheetBarController = BottomSheetBarController();
//侧边栏控制器
GlobalKey<SideMenuState> _sideMenuKey =
    GlobalKey<SideMenuState>(debugLabel: UniqueKey().toString());
GlobalKey<SideMenuState> _sideMenuKey2 =
    GlobalKey<SideMenuState>(debugLabel: UniqueKey().toString());
GlobalKey<SideMenuState> _endSideMenuKey =
    GlobalKey<SideMenuState>(debugLabel: UniqueKey().toString());
String title = '今日课程';

var date;
var widthx;
bool _isVerticalDrag = false;
Offset _dragStartPos = Offset.zero;

ImageProvider logopic = AssetImage('images/logo.png');
ImageProvider calendarlogo = AssetImage('images/logo.png');

class HomePage extends StatefulWidget {
  var homecontext;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RiveAnimationController _controller = SimpleAnimation('行走');
  late RiveAnimationController _controller2;
  RiveAnimationController _controller3 = SimpleAnimation('行走');
  bool _isPlaying = false;
  bool _isStanding = true;
  int _standingTime = 0;
  String localversion = '';
  String _cancelTag = "";
  String _apkFilePath = "";
  String _currentDownloadStateCH = "当前下载状态：还未开始";
  var _currentIndex = 0;
  Widget home_body(isfront) {
    if (isfront)
      return dailycourse.length == 0
          ? Container(
              child: GestureDetector(
                onTap: _onTap,
                child: RiveAnimation.asset(
                  'assets/tomadoro_v3.riv',
                  animations: const [
                    '惊吓',
                    '休息',
                    '站立转休息',
                    '惊吓转站立',
                    '站立',
                    '开始站立',
                    '什么都不做'
                  ],
                  controllers: [_controller2],
                ),
              ),
            )
          : Container(
              //padding靠左
              child: Scaffold(
                body: ListView(
                  children: dailycourse,
                ),
              ),
            );
    else
      return dailycourse2.length == 0
          ? Container(
              child: GestureDetector(
                onTap: _onTap,
                child: RiveAnimation.asset(
                  'assets/tomadoro_v3.riv',
                  animations: const [
                    '惊吓',
                    '休息',
                    '站立转休息',
                    '惊吓转站立',
                    '站立',
                    '开始站立',
                    '什么都不做'
                  ],
                  controllers: [_controller2],
                ),
              ),
            )
          : Container(
              //padding靠左
              child: Scaffold(
                body: ListView(
                  children: dailycourse2,
                ),
              ),
            );
  }

  @override
  void dispose() {
    _controller3.dispose();
    super.dispose();
  }

  bool isOpened = false;
  bool isdownload = true;
  bool isDarkModeEnabled = false;
  toggleMenu([bool end = false]) {
    if (end) {
      final _state = _endSideMenuKey.currentState!;
      if (_state.isOpened) {
        print("关闭1");
        _state.closeSideMenu();
        Global.bottombarheight = 60;
      } else {
        print("打开1");
        Global.bottombarheight = 0;
        _state.openSideMenu();
      }
    } else {
      final _state = _sideMenuKey.currentState!;
      if (_state.isOpened) {
        print("关闭2");
        _state.closeSideMenu();
      } else {
        print("打开2");
        _state.openSideMenu();
      }
    }
  }

  void changeColor(Color color) {
    setState(() => Global.home_pickcolor = color);
  }

  void showAchievementView(
      BuildContext context, String version, String notice, File file) {
    AchievementView(
        title: "新通知!",
        subTitle: notice,
        color: Global.home_currentcolor,
        duration: Duration(seconds: 10),
        isCircle: true, listener: (status) {
      if (status.toString() == 'AchievementState.closed') {
        file.writeAsString(version);
      }
    })
      ..show(context);
  }

  void showTutorial() {
    TutorialCoachMark(
        targets: Global().targets, // List<TargetFocus>
        colorShadow: Colors.red, // DEFAULT Colors.black
        onFinish: () {
          getApplicationDocumentsDirectory().then((value) {
            File file = new File(value.path + '/yindao.txt');
            file.exists().then((value) {
              if (value) {
              } else {
                file.create();
              }
            });
          });
        },
        onClickTargetWithTapPosition: (target, tapDetails) {
          print("target: $target");
          print(
              "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
        },
        onClickTarget: (target) {
          print(target);
        },
        onSkip: () {
          getApplicationDocumentsDirectory().then((value) {
            File file = new File(value.path + '/yindao.txt');
            file.exists().then((value) {
              if (value) {
              } else {
                file.create();
              }
            });
          });
        })
      ..show(context: context);
  }

  String shijian() {
    //判断上午下午晚上
    var hour = DateTime.now().hour;

    if (hour >= 0 && hour < 6) {
      return '凌晨了，怎么不睡呢';
    } else if (hour >= 6 && hour < 9) {
      return '早上好,今天要有个好心情哦';
    } else if (hour >= 9 && hour < 12) {
      return '上午好，快要吃午饭了';
    } else if (hour >= 12 && hour < 14) {
      return '中午好，午休时间到了';
    } else if (hour >= 14 && hour < 18) {
      return '下午好哦';
    } else {
      return '晚上好，今天过得怎么样';
    }
  }

  DateTime _selectedIndex = DateTime.now();
  CalendarAgendaController _calendarAgendaControllerAppBar =
      CalendarAgendaController();
  CalendarAgendaController _calendarAgendaControllerAppBar2 =
      CalendarAgendaController();
  Future<void> getcolor() async {
    getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/color.txt');
      if (file.existsSync()) {
        file.readAsString().then((value) {
          setState(() {
            Global.home_currentcolor = Color(int.parse(value));
            Global.home_pickcolor = Color(int.parse(value));
          });
        });
      }
    });
    setState(() {});
  }

  void xinshouyindao() {
    getApplicationDocumentsDirectory().then((value) {
      File file = new File(value.path + '/yindao.txt');
      file.exists().then((value) {
        if (!value) {
          showTutorial();
        }
      });
    });
  }

  void _onTap() {
    if (_isPlaying) {
      _controller2.isActive = false;
      setState(() {
        _isPlaying = false;
        _isStanding = true;
        _standingTime = 0;
      });
    } else {
      _controller2 = OneShotAnimation(
        _isStanding ? '惊吓转站立' : '惊吓',
        onStop: () {
          setState(() {
            _isPlaying = false;
            _isStanding = true;
            _standingTime = 0;
            //随机0-1
            var random = Random().nextInt(2);
            if (random == 0)
              _controller2 = SimpleAnimation('站立');
            else
              _controller2 = SimpleAnimation('休息');
          });
        },
        onStart: () => setState(() => _isPlaying = true),
      );
      _controller2.isActiveChanged.addListener(() {
        if (_controller2.isActive) {
          setState(() => _isStanding = false);
        }
      });
      _controller2..isActive = true;
    }
  }

  void initState() {
    super.initState();
    Global().showad(context);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });

    Global.pureyzmset(false);
    // Global().getxuehao();
    _controller2 = SimpleAnimation('站立');
    Future.delayed(Duration(seconds: 4), () {
      if (!_isPlaying) {
        setState(() {
          _isStanding = false;
          _controller2 = SimpleAnimation('休息');
          _controller2.isActive = true;
        });
      }
    });
    bottomSheetBarController.addListener(() {
      if (bottomSheetBarController.isExpanded == true) {
      } else {
        setState(() {
          Global.locked = false;
        });
      }
    });
    homecontext = context;

    getcolor();
    initAll();
    ApiService().updateappx(context, _cancelTag);
    xinshouyindao();
    ApiService().shownotice(context);
  }

  void initAll() async {
    final dir = await getApplicationDocumentsDirectory();
    final dio = Dio();
    final courseFile = File('${dir.path}/course.json');
    final scoreFile = File('${dir.path}/score.json');
    if (!courseFile.existsSync()) {
      firstdownload(await Global().getLoginInfo(), 'course.json', 'score.json');
    } else {
      await ApiService().updateCourseFromJW(
          dio, courseFile, context, true, scoreFile, hItems);
      if (Platform.isWindows) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return windwosfloat();
        }));
      }
    }
  }

  //展示通知
  void showupdatenotice(BuildContext context, int second, String title,
      String subtitle, Icon icon, Color color) {
    AchievementView(
        title: title,
        subTitle: subtitle,
        icon: icon,
        color: color,
        duration: Duration(seconds: second),
        isCircle: true,
        listener: (status) {})
      ..show(context);
  }

  var homecontext;

  void firstdownload(
      String loginInfo, String fileName, String courseFileName) async {
    ProgressDialog pd = ProgressDialog(context: context);
    var dio = Dio();
    pd.show(
      backgroundColor: Global.home_currentcolor,
      max: 100,
      msg: '服务器正在加工你的成绩数据哦，不是卡住了，请稍等...,后续更新可以在成绩页面检查更新，速度更快',
      msgMaxLines: 5,
      completed: Completed(
        completedMsg: "下载完成!",
        completedImage: AssetImage("assets/completed.gif"),
        completionDelay: 2500,
      ),
    );

    var url =
        'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/course' +
            loginInfo;

    getApplicationDocumentsDirectory().then((value) async {
      isdownload = false;
      try {
        Response response = await dio.get(url);
        if (response.statusCode == 500) {
          pd.close();
          print('下载失败');
          return;
        } else if (response.statusCode == 200) {
          Directory directory = await getApplicationDocumentsDirectory();
          String path = directory.path + '/' + fileName;
          if (!response.data.toString().contains('fail')) {
            //写入文件
            File file = new File(path);
            file.writeAsString(response.data);
            setState(() {
              title = '下载成绩中';
            });
            jpushs().uploadpushid();
            var urlscore =
                'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/getscore' +
                    loginInfo;

            getApplicationDocumentsDirectory().then((value) {
              dio.download(urlscore, value.path + '/' + courseFileName,
                  onReceiveProgress: (int count, int total) {
                int progress = (((count / total) * 100).toInt());
                pd.update(value: progress, msg: '久等了，数据正在下载...');
                setState(() {});
              }).then((value) async {
                pd.close();
                Global().getlist();
                //下载完成
                isdownload = true;
                hItems(DateTime.now());
                xinshouyindao();
              });
            });
          } else {
            if (fileName == 'course.json') {
              ApiService.noPerceptionLogin().then((value) =>
                  firstdownload(loginInfo, fileName, courseFileName));
            }
          }
        }
      } catch (e) {
        ApiService.noPerceptionLogin().then(
            (value) => firstdownload(loginInfo, fileName, courseFileName));
        print(e);
        pd.close();
        return;
      }
    });
  }

  Widget _buildTimeContainer(String time) {
    return Container(
      padding: EdgeInsets.only(left: 60, top: 30),
      child: Row(
        children: [
          Text(
            time,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Global.home_currentcolor),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseTile(
      String time, bool hasStartConnector, bool hasEndConnector) {
    return Container(
      child: TimelineTile(
        oppositeContents: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Container(
              width: widthx,
              padding: EdgeInsets.all(8.0),
              child: Text(
                time,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        contents: Card(
          //透明
          // color: Colors.transparent,
          shadowColor: Colors.transparent,
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
    );
  }

  loadwidget(DateTime date) {
    var eventcahe = [];
    //如果date不是今天则修改title为非本日课程
    if (date.toString().substring(0, 10) !=
        DateTime.now().toString().substring(0, 10)) {
      title = '非本日课程';
    } else {
      title = '今日课程';
    }
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
      });
    }
    //对eventcahe进行排序
    eventcahe.sort((a, b) {
      return a['qssj'].toString().compareTo(b['qssj'].toString());
    });

    dailycourse = [
      _buildTimeContainer('上午'),
      _buildCourseTile('1,2节\n08:00 - 09:35', false, true),
      _buildCourseTile('3,4节\n09:55 - 11:30', true, false),
      _buildTimeContainer('下午'),
      _buildCourseTile('5,6节\n13;30 - 15:05', false, true),
      _buildCourseTile('7,8节\n15:25 - 17:00', true, false),
      _buildTimeContainer('晚课'),
      _buildCourseTile('9,10节\n18:00 - 19:35', false, true),
      _buildCourseTile('11,12节\n19:55 - 21:30', true, false),
    ];
    if (eventcahe.length == 0) {
      dailycourse = [];
      print('dailycourse为空');
    }
    for (var i = 0; i < eventcahe.length; i++) {
      var qssj = eventcahe[i]['qssj'].toString().split(' ')[0];
      var jssj = eventcahe[i]['jssj'].toString().split(' ')[0];
      var msg = '课程名称:' +
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
      //判断课程时间段，替换对应的Container
      //08,09,11,13,15,17,18,21
      if (qssj.substring(0, 2) == '08') {
        dailycourse[1] = Course.coursedetail(
            '1,2节', i, msg, eventcahe, false, true, widthx, context);
      }
      if (qssj.substring(0, 2) == '09') {
        dailycourse[2] = Course.coursedetail(
            '3,4节', i, msg, eventcahe, true, false, widthx, context);
      }
      if (jssj.substring(0, 2) == '11') {
        dailycourse[2] = Course.coursedetail(
            '3,4节', i, msg, eventcahe, true, false, widthx, context);
      }
      if (qssj.substring(0, 2) == '13') {
        dailycourse[4] = Course.coursedetail(
            '5,6节', i, msg, eventcahe, false, true, widthx, context);
      }
      if (qssj.substring(0, 2) == '15') {
        dailycourse[5] = Course.coursedetail(
            '7,8节', i, msg, eventcahe, true, false, widthx, context);
      }
      if (jssj.substring(0, 2) == '17') {
        dailycourse[5] = Course.coursedetail(
            '7,8节', i, msg, eventcahe, true, false, widthx, context);
      }
      if (qssj.substring(0, 2) == '18') {
        dailycourse[7] = Course.coursedetail(
            '9,10节', i, msg, eventcahe, false, true, widthx, context);
      }
      if (jssj.substring(0, 2) == '21') {
        dailycourse[8] = Course.coursedetail(
            '11,12节', i, msg, eventcahe, true, false, widthx, context);
      }
    }
    setState(() {});
  }

//刷新items
  hItems(DateTime date) async {
    var stopwatch = Stopwatch()..start(); // 创建 Stopwatch 对象并开始计时
    Global.calendar_current_day = date;
    await Global().loadItems(date);
    loadwidget(date);
    stopwatch.stop(); // 停止计时
    print('执行时间：${stopwatch.elapsedMilliseconds}毫秒');
  }

//可切换的主页组件
  Widget flipContainer(bool isfront) {
    return Scaffold(
        appBar: CalendarAgenda(
          controller: isfront
              ? _calendarAgendaControllerAppBar
              : _calendarAgendaControllerAppBar2,
          initialDate: DateTime.now(),
          appbar: true,
          calendarLogo: getcalanderlogopngx(),
          selectedDayLogo:
              getlogopngx(), //使用ImageProvider<Object>加载IMage类型的logopic
          backgroundColor: Global.home_currentcolor,
          firstDate: Global.calendar_first_day,
          lastDate: Global.calendar_last_day,
          locale: 'zh_CN',
          selectedDateColor: Colors.green.shade900,
          fullCalendarScroll: FullCalendarScroll.vertical,
          fullCalendarDay: WeekDay.long,
          dateColor: Colors.white,
          calendarEventColor: Global.home_currentcolor,
          events: Global.course_day,
          onDateSelected: (date) {
            hItems(date);
          },
        ),
        body: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (!_isVerticalDrag) {
                if (details.velocity.pixelsPerSecond.dx < 0) {
                  _calendarAgendaControllerAppBar.goToDay(
                      Global.calendar_current_day.add(Duration(days: 1)));
                } else if (details.velocity.pixelsPerSecond.dx > 0) {
                  _calendarAgendaControllerAppBar.goToDay(
                      Global.calendar_current_day.subtract(Duration(days: 1)));
                }
              }
            },
            onVerticalDragStart: (details) {
              _isVerticalDrag = true;
              _dragStartPos = details.globalPosition;
            },
            onVerticalDragUpdate: (details) {
              if (_isVerticalDrag) {
                double dy = details.globalPosition.dy - _dragStartPos.dy;
                if (dy.abs() > 50) {
                  // 阈值设为50
                  _isVerticalDrag = false;
                }
              }
            },
            onVerticalDragEnd: (details) {
              _isVerticalDrag = false;
              _dragStartPos = Offset.zero;
            },
            child: SideMenuBar.side(
                isfront,
                context,
                _sideMenuKey,
                _sideMenuKey2,
                changeColor,
                shijian,
                setState,
                toggleMenu,
                isOpened,
                scoredetailbtn,
                scoredetailbtn2,
                hItems,
                _controller,
                _calendarAgendaControllerAppBar,
                home_body,
                title,
                isdownload)));
  }

  Widget build(BuildContext context) {
    widthx = MediaQuery.of(context).size.width;

    return Container(
        child: Column(children: [
      getwindow(context),
      Expanded(
          child: Scaffold(
              bottomNavigationBar: Container(
                  //圆角
                  width: MediaQuery.of(context).size.width / 2,
                  child: 
                  flipContainer(true)),
          )
      )
        ]
        )
    );
  }

  Widget getwindow(context) {
    //判断是否是windows
    if (Platform.isWindows&&Global.desktop_float)
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

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:dio/dio.dart';
import 'package:flip_card/flip_card.dart' as flip;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muse_nepu_course/chatforgpt/chatgpt2.dart';
import 'package:muse_nepu_course/game/screens/welcome_screen.dart';
import 'package:muse_nepu_course/jpushs.dart';
import 'package:muse_nepu_course/login/chaoxinglogin.dart';
import 'package:muse_nepu_course/global.dart';
import 'package:muse_nepu_course/pingjiao/pingjiao.dart';
import 'package:muse_nepu_course/qingjia/qingjia.dart';
import 'package:muse_nepu_course/qrcode/qrcode.dart';
import 'package:muse_nepu_course/service/api_service.dart';
import 'package:muse_nepu_course/service/io_service.dart';
import 'package:muse_nepu_course/windowsfloat.dart';
import 'package:rive/rive.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'package:path_provider/path_provider.dart';
import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:timelines/timelines.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:window_manager/window_manager.dart';
import 'chaoxing/chaoxing.dart';
import 'coursemenu/about.dart';
import 'coursemenu/scoredetail.dart';
import 'dart:io';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_app_installer/easy_app_installer.dart';
import 'package:achievement_view/achievement_view.dart';

import 'ins.dart';

List<Widget> dailycourse = [];
List<Widget> dailycourse2 = [];
GlobalKey scoredetailbtn = GlobalKey();
GlobalKey scoredetailbtn2 = GlobalKey();
GlobalKey<flip.FlipCardState> cardKey = GlobalKey<flip.FlipCardState>();

//上滑控制器
BottomSheetBarController bottomSheetBarController = BottomSheetBarController();
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
//侧边栏控制器
GlobalKey<SideMenuState> _sideMenuKey =
    GlobalKey<SideMenuState>(debugLabel: UniqueKey().toString());
GlobalKey<SideMenuState> _sideMenuKey2 =
    GlobalKey<SideMenuState>(debugLabel: UniqueKey().toString());
GlobalKey<SideMenuState> _endSideMenuKey =
    GlobalKey<SideMenuState>(debugLabel: UniqueKey().toString());
GlobalKey<SideMenuState> _endSideMenuKey2 =
    GlobalKey<SideMenuState>(debugLabel: UniqueKey().toString());
String title = '今日课程';
String title2 = '今日课程';

var date;
var widthx;
bool _isVerticalDrag = false;
Offset _dragStartPos = Offset.zero;

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
        image: null,
        shape: BoxShape.circle,
      ),
    );
  }
}

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

  void updateappx() async {
    var value = await getApplicationDocumentsDirectory();
    var pathx = value.path;
    File file = File('$pathx/version.txt');
    if (await file.exists()) {
      String localVersion = await file.readAsString();
      var dio = Dio();
      var value = await dio.get(
          'https://update-nepucouseupdate-bmgwsddxxl.cn-hongkong.fcapp.run/update');
      String version = value.data[0]['version'];
      if (version != Global.version && version != localVersion) {
        await Dialogs.materialDialog(
          color: Colors.white,
          msg: '要下载吗?',
          title: '有新版本啦,版本号是$version\n${value.data[0]['descrption']}',
          lottieBuilder: Lottie.asset(
            'assets/rockert-new.json',
            fit: BoxFit.contain,
          ),
          context: context,
          actions: [
            IconButton(
              onPressed: () {
                file.writeAsString(version);
                Navigator.pop(context);
              },
              icon: Icon(Icons.cancel_outlined),
            ),
            IconButton(
              onPressed: () async {
                file.writeAsString(version);
                Navigator.pop(context);
                if (Platform.isAndroid) {
                  ProgressDialog pd = ProgressDialog(context: context);
                  pd.show(
                      max: 100,
                      msg: '准备下载更新...',
                      msgMaxLines: 5,
                      completed: Completed(
                        completedMsg: "下载完成!",
                        completedImage: AssetImage("assets/completed.gif"),
                        completionDelay: 2500,
                      ));
                  await EasyAppInstaller.instance.downloadAndInstallApk(
                    fileUrl: value.data[0]['link'],
                    fileDirectory: "updateApk",
                    fileName: "newApk.apk",
                    explainContent: "快去开启权限！！！",
                    onDownloadingListener: (progress) {
                      if (progress < 100) {
                        pd.update(value: progress.toInt(), msg: '安装包正在下载...');
                      } else {
                        pd.update(value: progress.toInt(), msg: '安装包下载完成...');
                      }
                    },
                    onCancelTagListener: (cancelTag) {
                      _cancelTag = cancelTag;
                    },
                  );
                } else {
                  Clipboard.setData(ClipboardData(
                      text:
                          'https://wwai.lanzouy.com/b02pwpe5e?password=4huv'));
                  AchievementView(context,
                      title: "复制成功",
                      subTitle: '请手动去浏览器粘贴网址，密码是4huv，请手动下载对应您的平台',
                      icon: Icon(
                        Icons.insert_emoticon,
                        color: Colors.white,
                      ),
                      color: Colors.green,
                      duration: Duration(seconds: 15),
                      isCircle: true, listener: (status) {
                    print(status);
                  })
                    ..show();
                }
              },
              icon: Icon(Icons.check),
            ),
          ],
        );
      }
    } else {
      await file.create();
      if (await file.exists()) {
        var dio = Dio();
        var value = await dio.get(
            'https://update-nepucouseupdate-bmgwsddxxl.cn-hongkong.fcapp.run/update');
        String version = value.data[0]['version'];
        if (version != Global.version) {
          await Dialogs.materialDialog(
            color: Colors.white,
            msg: '要下载吗?',
            title: '有新版本啦,版本号是$version\n${value.data[0]['descrption']}',
            lottieBuilder: Lottie.asset(
              'assets/rockert-new.json',
              fit: BoxFit.contain,
            ),
            context: context,
            actions: [
              IconButton(
                onPressed: () {
                  file.writeAsString(version);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.cancel_outlined),
              ),
              IconButton(
                onPressed: () async {
                  if (Platform.isAndroid) {
                    ProgressDialog pd = ProgressDialog(context: context);
                    pd.show(
                        max: 100,
                        msg: '准备下载更新...',
                        msgMaxLines: 5,
                        completed: Completed(
                          completedMsg: "下载完成!",
                          completedImage: AssetImage("assets/completed.gif"),
                          completionDelay: 2500,
                        ));
                    await EasyAppInstaller.instance.downloadAndInstallApk(
                      fileUrl: value.data[0]['link'],
                      fileDirectory: "updateApk",
                      fileName: "newApk.apk",
                      explainContent: "快去开启权限！！！",
                      onDownloadingListener: (progress) {
                        if (progress < 100) {
                          pd.update(value: progress.toInt(), msg: '安装包正在下载...');
                        } else {
                          pd.update(value: progress.toInt(), msg: '安装包下载完成...');
                        }
                      },
                      onCancelTagListener: (cancelTag) {
                        _cancelTag = cancelTag;
                      },
                    );
                  } else {
                    Clipboard.setData(ClipboardData(
                        text:
                            'https://wwai.lanzouy.com/b02pwpe5e?password=4huv'));
                    AchievementView(context,
                        title: "复制成功",
                        subTitle: '请手动去浏览器粘贴网址，密码是4huv，请手动下载对应您的平台',
                        icon: Icon(
                          Icons.insert_emoticon,
                          color: Colors.white,
                        ),
                        color: Colors.green,
                        duration: Duration(seconds: 15),
                        isCircle: true, listener: (status) {
                      print(status);
                    })
                      ..show();
                  }
                },
                icon: Icon(Icons.check),
              ),
            ],
          );
        }
      }
    }
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

  @override
  void changeColor(Color color) {
    setState(() => Global.home_pickcolor = color);
  }

  void shownotice() {
    var dio = Dio();
    dio
        .get(
            'https://update-nepucouseupdate-bmgwsddxxl.cn-hongkong.fcapp.run/notice')
        .then((value) {
      //截取json中的version
      String version = value.data[0]['version'];
      String notice = value.data[0]['notice'];
      getApplicationDocumentsDirectory().then((value) {
        File file = new File(value.path + '/notice.txt');
        file.exists().then((value) {
          if (value) {
            file.readAsString().then((value) {
              if (version.toString() != value.toString()) {
                AchievementView(context,
                    title: "新通知!",
                    subTitle: notice.toString(),
                    //onTab: _onTabAchievement,
                    //icon: Icon(Icons.insert_emoticon, color: Colors.white,),
                    //typeAnimationContent: AnimationTypeAchievement.fadeSlideToUp,
                    //borderRadius: 5.0,
                    color: Global.home_currentcolor,
                    //textStyleTitle: TextStyle(),
                    //textStyleSubTitle: TextStyle(),
                    //alignment: Alignment.topCenter,
                    duration: Duration(seconds: 10),
                    isCircle: true, listener: (status) {
                  print(status);
                  if (status.toString() == 'AchievementState.closed') {
                    print("通知结束");
                    //将版本号写入
                    file.writeAsString(version.toString());
                  }
                })
                  ..show();
              }
            });
          } else {
            file.create();
            file.writeAsString(version.toString());
            AchievementView(context,
                title: "新通知!",
                subTitle: notice.toString(),
                //onTab: _onTabAchievement,
                //icon: Icon(Icons.insert_emoticon, color: Colors.white,),
                //typeAnimationContent: AnimationTypeAchievement.fadeSlideToUp,
                //borderRadius: 5.0,
                color: Global.home_currentcolor,
                //textStyleTitle: TextStyle(),
                //textStyleSubTitle: TextStyle(),
                //alignment: Alignment.topCenter,
                duration: Duration(seconds: 10),
                isCircle: true, listener: (status) {
              print(status);
              if (status.toString() == 'AchievementState.closed') {
                print("通知结束");
                //将版本号写入
                file.writeAsString(version.toString());
              }
            })
              ..show();
          }
        });
      });
    });
  }

  void showTutorial() {
    TutorialCoachMark tutorial = TutorialCoachMark(
        targets: targets, // List<TargetFocus>
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
    if (Global.yikatong_balance == '') {
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
    } else
      return '你的一卡通总余额：' + Global.yikatong_balance + '元(点击查看近期流水)';
  }

  DateTime _selectedIndex = DateTime.now();
  CalendarAgendaController _calendarAgendaControllerAppBar =
      CalendarAgendaController();
  CalendarAgendaController _calendarAgendaControllerAppBar2 =
      CalendarAgendaController();
  @override
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
    initall();
    initall2();
  }

  void initall() {
    getApplicationDocumentsDirectory().then((value) {
      Dio dio = new Dio();
      File file = new File(value.path + '/course.json');
      file.exists().then((value) {
        if (!value) {
          //没有则下载
          downApkFunction();
        } else {
          hItems(DateTime.now());
          if (Global.auto_update_course) if (!Global.isrefreshcourse)
            ApiService.noPerceptionLogin().then((value) async {
              Global.isrefreshcourse = true;
              var url =
                  'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/course' +
                      await Global().getLoginInfo();
              getApplicationDocumentsDirectory().then((value) async {
                //判断响应状态
                Response response = await dio.get(url);
                if (response.statusCode == 500) {
                  AchievementView(context,
                      title: "与教务同步最新课程失败!",
                      subTitle: '可能是服务器出现短暂问题，请稍后再试',
                      icon: Icon(
                        Icons.error,
                        color: Colors.white,
                      ),
                      color: Colors.red,
                      duration: Duration(seconds: 3),
                      isCircle: true,
                      listener: (status) {})
                    ..show();
                  return;
                } else if (response.statusCode == 200) {
                  if (!response.data.toString().contains('fail')) {
                    Directory directory =
                        await getApplicationDocumentsDirectory();
                    String path = directory.path + '/course.json';
                    File file = new File(path);
                    file.writeAsString(response.data);
                    Global.isfirstread = true;
                    jpushs().uploadpushid();

                    var urlscore =
                        'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/getnewscore' +
                            await Global().getLoginInfo() +
                            '&index=' +
                            Global.scoreinfos[Global.scoreinfos.length - 1]
                                    ['cjdm']
                                .toString();
                    print(urlscore);
                    getApplicationDocumentsDirectory().then((value) async {
                      try {
                        Response response = await dio.get(urlscore);
                        if (response.statusCode == 200) {
                          //获取路径
                          Directory directory =
                              await getApplicationDocumentsDirectory();
                          String path = directory.path + '/score.json';
                          //追加文件
                          File file = new File(path);
                          file.readAsString().then((value) {
                            value = value.replaceAll(']', '') +
                                ',' +
                                response.data.toString().replaceAll('[', '');
                            file.writeAsString(value);
                            Global().getlist();
                          });
                          Dialogs.materialDialog(
                            color: Colors.white,
                            msg: '去看看不?',
                            title: '有新成绩啦!',
                            lottieBuilder: Lottie.asset(
                              'assets/rockert-new.json',
                              fit: BoxFit.contain,
                            ),
                            context: context,
                            actions: [
                              IconButton(
                                onPressed: () {
                                  //关闭
                                },
                                icon: Icon(Icons.cancel_outlined),
                              ),
                              IconButton(
                                onPressed: () async {
                                  //跳转到score页面
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => scorepage()));
                                },
                                icon: Icon(Icons.check),
                              ),
                            ],
                          );
                        }
                      } catch (e) {
                        print(e);
                      }
                    });
                    AchievementView(context,
                        title: "课程获取成功啦!",
                        subTitle: '你的课程已经同步至最新',
                        icon: Icon(
                          Icons.error,
                          color: Colors.white,
                        ),
                        color: Global.home_currentcolor,
                        duration: Duration(seconds: 3),
                        isCircle: true,
                        listener: (status) {})
                      ..show();
                  } else {
                    AchievementView(context,
                        title: "与教务同步课程失败!",
                        subTitle: '请检查你的密码或者教务系统是否正常',
                        icon: Icon(
                          Icons.error,
                          color: Colors.white,
                        ),
                        color: Colors.red,
                        duration: Duration(seconds: 3),
                        isCircle: true,
                        listener: (status) {})
                      ..show();
                    return;
                  }
                }
              });
            });
          //有则读取
          //判断是否windows
          if (Platform.isWindows) {
            //跳转到windows页面
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return windwosfloat();
            }));
          }
          //判断是否web
          updateappx();
          xinshouyindao();
          shownotice();
        }
      });
    });
  }

  void initall2() {
    Global.isfirstread2 = true;
    if (Global.islogin2)
      getApplicationDocumentsDirectory().then((value) {
        Dio dio = new Dio();
        File file = new File(value.path + '/course1.json');
        file.exists().then((value) {
          if (!value) {
            ApiService.noPerceptionLogin2().then((value) {
              downApkFunction2();
            });
          } else {
            hItems(DateTime.now());
            if (Global.auto_update_course) if (!Global.isrefreshcourse2)
              ApiService.noPerceptionLogin2().then((value) async {
                Global.isrefreshcourse2 = true;
                print('开始同步用户2课程');
                var url =
                    'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/course' +
                        await Global().getLoginInfo2();
                getApplicationDocumentsDirectory().then((value) async {
                  //判断响应状态
                  Response response = await dio.get(url);
                  if (response.statusCode == 500) {
                    AchievementView(context,
                        title: "与教务同步最新课程失败!",
                        subTitle: '可能是服务器出现短暂问题，请稍后再试',
                        icon: Icon(
                          Icons.error,
                          color: Colors.white,
                        ),
                        color: Colors.red,
                        duration: Duration(seconds: 3),
                        isCircle: true,
                        listener: (status) {})
                      ..show();
                    return;
                  } else if (response.statusCode == 200) {
                    if (!response.data.toString().contains('fail')) {
                      Directory directory =
                          await getApplicationDocumentsDirectory();
                      String path = directory.path + '/course1.json';
                      File file = new File(path);
                      file.writeAsString(response.data);
                      Global.isfirstread2 = true;

                      var urlscore =
                          'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/getnewscore' +
                              await Global().getLoginInfo2() +
                              '&index=' +
                              Global.scoreinfos2[Global.scoreinfos2.length - 1]
                                      ['cjdm']
                                  .toString();
                      print(urlscore);
                      getApplicationDocumentsDirectory().then((value) async {
                        try {
                          Response response = await dio.get(urlscore);
                          if (response.statusCode == 200) {
                            //获取路径
                            Directory directory =
                                await getApplicationDocumentsDirectory();
                            String path = directory.path + '/score1.json';
                            //追加文件
                            File file = new File(path);
                            file.readAsString().then((value) {
                              value = value.replaceAll(']', '') +
                                  ',' +
                                  response.data.toString().replaceAll('[', '');
                              file.writeAsString(value);
                              Global().getlist2();
                            });
                            Dialogs.materialDialog(
                              color: Colors.white,
                              msg: '去看看不?',
                              title: '有新成绩啦!',
                              lottieBuilder: Lottie.asset(
                                'assets/rockert-new.json',
                                fit: BoxFit.contain,
                              ),
                              context: context,
                              actions: [
                                IconButton(
                                  onPressed: () {
                                    //关闭
                                  },
                                  icon: Icon(Icons.cancel_outlined),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    //跳转到score页面
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => scorepage()));
                                  },
                                  icon: Icon(Icons.check),
                                ),
                              ],
                            );
                          }
                        } catch (e) {
                          print(e);
                        }
                      });
                      AchievementView(context,
                          title: "课程获取成功啦!",
                          subTitle: '你的课程已经同步至最新',
                          icon: Icon(
                            Icons.error,
                            color: Colors.white,
                          ),
                          color: Global.home_currentcolor,
                          duration: Duration(seconds: 3),
                          isCircle: true,
                          listener: (status) {})
                        ..show();
                    } else {
                      AchievementView(context,
                          title: "与教务同步课程失败!",
                          subTitle: '请检查你的密码或者教务系统是否正常',
                          icon: Icon(
                            Icons.error,
                            color: Colors.white,
                          ),
                          color: Colors.red,
                          duration: Duration(seconds: 3),
                          isCircle: true,
                          listener: (status) {})
                        ..show();
                      return;
                    }
                  }
                });
              });
            //有则读取
            //判断是否windows
            if (Platform.isWindows) {
              //跳转到windows页面
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return windwosfloat();
              }));
            }
            hItems(DateTime.now());
          }
        });
      });
  }

  var homecontext;

  void downApkFunction() async {
    ProgressDialog pd = ProgressDialog(context: context);
    var dio = Dio();
    pd.show(
        max: 100,
        msg: '服务器正在加工你的成绩数据哦，不是卡住了，请稍等...,后续更新可以在成绩页面检查更新，速度更快',
        msgMaxLines: 5,
        completed: Completed(
          completedMsg: "下载完成!",
          completedImage: AssetImage
              //加载gif
              ("assets/completed.gif"),
          completionDelay: 2500,
        ));
    //下载课程
    var url =
        'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/course' +
            await Global().getLoginInfo();
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
          String path = directory.path + '/course.json';
          //写入文件
          File file = new File(path);
          file.writeAsString(response.data);
          setState(() {
            title = '下载成绩中';
          });
          jpushs().uploadpushid();
          var urlscore =
              'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/getscore' +
                  await Global().getLoginInfo();

          getApplicationDocumentsDirectory().then((value) {
            dio.download(urlscore, value.path + '/score.json',
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
        }
      } catch (e) {
        print(e);
        pd.close();
        return;
      }
      //下载完成后调用hitems
    });
  }

  void downApkFunction2() async {
    ProgressDialog pd = ProgressDialog(context: context);
    var dio = Dio();
    pd.show(
        max: 100,
        msg: '服务器正在加工你的成绩数据哦，不是卡住了，请稍等...,后续更新可以在成绩页面检查更新，速度更快',
        msgMaxLines: 5,
        completed: Completed(
          completedMsg: "下载完成!",
          completedImage: AssetImage
              //加载gif
              ("assets/completed.gif"),
          completionDelay: 2500,
        ));
    //下载课程
    var url =
        'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/course' +
            await Global().getLoginInfo2();
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
          String path = directory.path + '/course1.json';
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
                    await Global().getLoginInfo2();

            getApplicationDocumentsDirectory().then((value) {
              dio.download(urlscore, value.path + '/score1.json',
                  onReceiveProgress: (int count, int total) {
                int progress = (((count / total) * 100).toInt());
                pd.update(value: progress, msg: '久等了，数据正在下载...');
                setState(() {});
              }).then((value) async {
                pd.close();
                Global().getlist2();
                //下载完成
                isdownload = true;
                hItems(DateTime.now());
              });
            });
          } else {
            ApiService.noPerceptionLogin2().then((value) => downApkFunction2());
          }
        }
      } catch (e) {
        ApiService.noPerceptionLogin2().then((value) => downApkFunction2());

        print(e);
        pd.close();
        return;
      }
      //下载完成后调用hitems
    });
  }

  Container getContainer(String time, int index, String msg, eventcahe,
      bool hasStartConnector, bool hasEndConnector) {
    return Container(
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
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        contents: GestureDetector(
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
    );
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
      //判断课程时间段，替换对应的Container
      //08,09,11,13,15,17,18,21
      if (eventcahe[i]['qssj'].toString().split(' ')[0].substring(0, 2) ==
          '08') {
        dailycourse[1] = getContainer('1,2节', i, msg, eventcahe, false, true);
      } else if (eventcahe[i]['qssj']
              .toString()
              .split(' ')[0]
              .substring(0, 2) ==
          '09') {
        dailycourse[2] = getContainer('3,4节', i, msg, eventcahe, true, false);
      } else if (eventcahe[i]['jssj']
              .toString()
              .split(' ')[0]
              .substring(0, 2) ==
          '11') {
        dailycourse[2] = getContainer('3,4节', i, msg, eventcahe, true, false);
      } else if (eventcahe[i]['qssj']
              .toString()
              .split(' ')[0]
              .substring(0, 2) ==
          '13') {
        dailycourse[4] = getContainer('5,6节', i, msg, eventcahe, false, true);
      } else if (eventcahe[i]['qssj']
              .toString()
              .split(' ')[0]
              .substring(0, 2) ==
          '15') {
        dailycourse[5] = getContainer('7,8节', i, msg, eventcahe, true, false);
      } else if (eventcahe[i]['qssj']
              .toString()
              .split(' ')[0]
              .substring(0, 2) ==
          '17') {
        dailycourse[5] = getContainer('7,8节', i, msg, eventcahe, false, true);
      } else if (eventcahe[i]['qssj']
              .toString()
              .split(' ')[0]
              .substring(0, 2) ==
          '18') {
        dailycourse[7] = getContainer('9,10节', i, msg, eventcahe, false, true);
      } else if (eventcahe[i]['jssj']
              .toString()
              .split(' ')[0]
              .substring(0, 2) ==
          '21') {
        dailycourse[8] = getContainer('11,12节', i, msg, eventcahe, true, false);
      }
    }
    setState(() {});
  }

  loadwidget2(DateTime date) {
    var eventcahe = [];
    //如果date不是今天则修改title2为非本日课程
    if (date.toString().substring(0, 10) !=
        DateTime.now().toString().substring(0, 10)) {
      title2 = '非本日课程';
    } else {
      title2 = '今日课程';
    }
    var cacheindex = 0;
    var pos = 0;
    for (var i = 0; i < Global.courseInfox2.length; i++) {
      //判断是否是今天的课程
      if (Global.courseInfox2[i]['jsrq'] == date.toString().substring(0, 10)) {
        cacheindex++;
        eventcahe.add(Global.courseInfox2[i]);
      }
      //如果读取之后的时间在今天之前则跳过
      if (Global.courseInfox2[i]['jsrq']
              .compareTo(date.toString().substring(0, 10)) <
          0) {
        pos = i;
        break;
      }
    }

    //判断是否有课程
    if (cacheindex == 0) {
      //判断jsrq和date的日期差
      var date1 = DateTime.parse(Global.courseInfox2[pos]['jsrq']);
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

      int zc = Global.courseInfox2[pos]['zc'];
      if (difference > 0)
        zc = Global.courseInfox2[pos]['zc'] + //向上取整
            ((difference / 7).ceil());
      if (difference < 28)
        title2 = '第' + zc.toString() + '周' + '当天没课哦';
      else
        title2 = '假期中。。。';
    } else {
      setState(() {
        title2 = '第' + eventcahe[0]['zc'].toString() + '周' + title2;
      });
    }
    //对eventcahe进行排序
    eventcahe.sort((a, b) {
      return a['qssj'].toString().compareTo(b['qssj'].toString());
    });

    dailycourse2 = [
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
      dailycourse2 = [];
      print('dailycourse2为空');
    }
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
      //判断课程时间段，替换对应的Container
      //08,09,11,13,15,17,18,21
      if (eventcahe[i]['qssj'].toString().split(' ')[0].substring(0, 2) ==
          '08') {
        dailycourse2[1] = getContainer('1,2节', i, msg, eventcahe, false, true);
      } else if (eventcahe[i]['qssj']
              .toString()
              .split(' ')[0]
              .substring(0, 2) ==
          '09') {
        dailycourse2[2] = getContainer('3,4节', i, msg, eventcahe, true, false);
      } else if (eventcahe[i]['jssj']
              .toString()
              .split(' ')[0]
              .substring(0, 2) ==
          '11') {
        dailycourse2[2] = getContainer('3,4节', i, msg, eventcahe, true, false);
      } else if (eventcahe[i]['qssj']
              .toString()
              .split(' ')[0]
              .substring(0, 2) ==
          '13') {
        dailycourse2[4] = getContainer('5,6节', i, msg, eventcahe, false, true);
      } else if (eventcahe[i]['qssj']
              .toString()
              .split(' ')[0]
              .substring(0, 2) ==
          '15') {
        dailycourse2[5] = getContainer('7,8节', i, msg, eventcahe, true, false);
      } else if (eventcahe[i]['qssj']
              .toString()
              .split(' ')[0]
              .substring(0, 2) ==
          '17') {
        dailycourse2[5] = getContainer('7,8节', i, msg, eventcahe, false, true);
      } else if (eventcahe[i]['qssj']
              .toString()
              .split(' ')[0]
              .substring(0, 2) ==
          '18') {
        dailycourse2[7] = getContainer('9,10节', i, msg, eventcahe, false, true);
      } else if (eventcahe[i]['jssj']
              .toString()
              .split(' ')[0]
              .substring(0, 2) ==
          '21') {
        dailycourse2[8] =
            getContainer('11,12节', i, msg, eventcahe, true, false);
      }
    }
    setState(() {});
  }

//刷新items
  hItems(DateTime date) async {
    if (Global.isfirstuser) {
      print('用户1');
      Global.calendar_current_day = date;
      await Global().loadItems(date);
      loadwidget(date);
    } else {
      print('用户2');

      Global.calendar_current_day2 = date;
      await Global().loadItems2(date);
      loadwidget2(date);
    }
  }

//侧边
  Widget side(bool isfront) {
    return SideMenu(
        background: Global.home_currentcolor,
        key: isfront ? _sideMenuKey : _sideMenuKey2,
        menu: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 1.6,
                  child: RiveAnimation.asset(
                    'assets/cat.riv',
                    //缩小
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16.0),
                          TextButton(
                            onPressed: () => Global().getrecently(context),
                            child: Text(
                              shijian(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.cached,
                          size: 20.0, color: Colors.white),
                      title: Text(
                        '查看成绩',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => scorepage(),
                        ),
                      ),
                    ),
                    ListTile(
                        leading: const Icon(Icons.score_outlined,
                            size: 20.0, color: Colors.white),
                        title: Text(
                          'chatgpt',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatPage()));
                        }),
                    ListTile(
                      leading: const Icon(Icons.book_online,
                          size: 20.0, color: Colors.white),
                      title: Text(
                        '一键评教',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        ApiService.noPerceptionLogin().then((value) => null);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => pingjiao()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.book_online,
                          size: 20.0, color: Colors.white),
                      title: Text(
                        '请假历史',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        ApiService.noPerceptionLogin().then((value) => null);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => qingjia()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.colorize,
                          size: 20.0, color: Colors.white),
                      title: Text(
                        '调个色',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
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
                                        pickerColor: Global.home_currentcolor,
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
                                          setState(() =>
                                              Global.home_currentcolor =
                                                  Global.home_pickcolor);
                                          getApplicationDocumentsDirectory()
                                              .then((value) {
                                            File file =
                                                File(value.path + '/color.txt');
                                            //判断文件是否存在
                                            if (file.existsSync()) {
                                              //存在则写入
                                              file.writeAsString(Global
                                                  .home_currentcolor.value
                                                  .toString());
                                            } else {
                                              //不存在则创建文件并写入
                                              file.createSync();
                                              file.writeAsString(Global
                                                  .home_currentcolor.value
                                                  .toString());
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
                    ListTile(
                        leading: const Icon(Icons.score_outlined,
                            size: 20.0, color: Colors.white),
                        title: Text(
                          '查看学习通考试成绩',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          getApplicationDocumentsDirectory()
                              .then((value) async {
                            //读取chaoxing.txt
                            var file =
                                await new File(value.path + "/chaoxing.txt");
                            //如果文件存在，就跳转到成绩页面
                            if (file.existsSync()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => chaoxing()),
                              );
                            } else {
                              //如果文件不存在，就跳转到登录页面
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => chaoxinglogin()),
                              );
                            }
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => chaoxinglogin()));
                        }),
                    ListTile(
                      leading: const Icon(Icons.cached,
                          size: 20.0, color: Colors.white),
                      title: Text(
                        '重新登入',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        io_service().deleteFiles();
                        AchievementView(context,
                            title: "成功!",
                            subTitle: "已清除课程和成绩缓存，请退出app重新登录",
                            //onTab: _onTabAchievement,
                            icon: Icon(
                              Icons.insert_emoticon,
                              color: Colors.white,
                            ),
                            //typeAnimationContent: AnimationTypeAchievement.fadeSlideToUp,
                            //borderRadius: 5.0,
                            color: Colors.green,
                            //textStyleTitle: TextStyle(),
                            //textStyleSubTitle: TextStyle(),
                            //alignment: Alignment.topCenter,
                            duration: Duration(seconds: 3),
                            isCircle: true, listener: (status) {
                          print(status);
                        })
                          ..show();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings,
                          size: 20.0, color: Colors.white),
                      title: Text(
                        '关于&设置',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => about()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            )),
        type: SideMenuType.slideNRotate,
        onChange: (_isOpened) {
          if (isOpened) {
            Global.bottombarheight = 60;
          } else {
            Global.bottombarheight = 0;
          }
          setState(() => isOpened = _isOpened);
        },
        child: IgnorePointer(
            ignoring: isOpened,
            child: Scaffold(
              appBar: AppBar(
                  backgroundColor: Global.home_currentcolor,
                  title: Text(title),
                  centerTitle: true,
                  leading: isfront
                      ? IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            toggleMenu();
                          },
                        )
                      : Container(),
                  actions: [
                    IconButton(
                      key: isfront ? scoredetailbtn : scoredetailbtn2,
                      icon: Icon(Icons.score),
                      onPressed: () {
                        if (isdownload) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => scorepage()),
                          );
                        } else {
                          AchievementView(context,
                              title: "出错啦!",
                              subTitle: '请确认现在是否学校在抢课或其他原因导致成绩下载超时',
                              //onTab: _onTabAchievement,
                              icon: Icon(
                                Icons.error,
                                color: Colors.white,
                              ),
                              color: Colors.red,
                              duration: Duration(seconds: 3),
                              isCircle: true, listener: (status) {
                            print(status);
                          })
                            ..show();
                        }
                      },
                    ),
                  ]),
              body: home_body(isfront),
              floatingActionButton: Stack(children: [
                MaterialButton(
                  onPressed: () {
                    _controller = SimpleAnimation('起飞');
                    Future.delayed(Duration(seconds: 2), () {
                      _controller = SimpleAnimation('保持飞翔');
                      _controller = SimpleAnimation('降落');
                      Future.delayed(Duration(seconds: 2), () {
                        _controller = SimpleAnimation('行走');
                      });
                    });
                    hItems(DateTime.now());
                    setState(() {
                      print('回到今天');
                      _calendarAgendaControllerAppBar.goToDay(DateTime.now());
                    });
                  },
                  child: Text(
                    '回到今天',
                  ),
                  shape: StadiumBorder(),
                  textColor: Colors.white,
                  color: Global.home_currentcolor,
                ),
                GestureDetector(
                  onTap: () {
                    _controller = SimpleAnimation('起飞');
                    Future.delayed(Duration(seconds: 2), () {
                      _controller = SimpleAnimation('保持飞翔');
                      _controller = SimpleAnimation('降落');
                      Future.delayed(Duration(seconds: 2), () {
                        _controller = SimpleAnimation('行走');
                      });
                    });
                    hItems(DateTime.now());
                    setState(() {
                      print('回到今天');
                      _calendarAgendaControllerAppBar.goToDay(DateTime.now());
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.17,
                    height: MediaQuery.of(context).size.width * 0.17,
                    child: RiveAnimation.asset(
                      'assets/birds.riv',
                      controllers: [_controller],
                      animations: ['行走', '起飞', '保持飞翔', '降落'],
                    ),
                  ),
                ),
              ]),
            )));
  }

//可切换的主页组件
  Widget flipContainer(bool isfront) {
    if (!isfront && !Global.islogin2) {
      return Scaffold(
        appBar: AppBar(
          title: IconButton(
            icon: Icon(Icons.tab_rounded),
            onPressed: () {
              setState(() {
                Global.isfirstuser = !Global.isfirstuser;

                cardKey.currentState!.toggleCard();
              });
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '欢迎来到用户2的登录页面。\n请输入解密密钥来解锁用户2继续操作。密钥获取可以在想要看的用户的设置页面获取。',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: Global.textEditingController,
                decoration: InputDecoration(
                  labelText: '解密密钥',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (Global().Decrypt(
                          Global.textEditingController.text, context) ==
                      'success') {
                    Global.isfirstuser = !Global.isfirstuser;

                    cardKey.currentState!.toggleCard();
                    cardKey.currentState!.toggleCard();
                    initall2();
                  }
                },
                child: Text('解密'),
              ),
              SizedBox(height: 32.0),
              Text(
                '或者使用以下方式登录用户2：但是目前并不开放哦，\n作者为了提升用户的数量，以及真的很懒，懒得去改代码了，所以暂定不开放',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '用户名',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '密码',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {},
                child: Text('登陆'),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: CalendarAgenda(
        leading: IconButton(
          icon: Icon(Icons.swap_horizontal_circle_outlined),
          color: Colors.white,
          onPressed: () {
            Global.isfirstuser = !Global.isfirstuser;

            cardKey.currentState!.toggleCard();
          },
        ),
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
                if (isfront) {
                  hItems(Global.calendar_current_day.add(Duration(days: 1)));
                  _calendarAgendaControllerAppBar
                      .goToDay(Global.calendar_current_day);
                } else {
                  hItems(Global.calendar_current_day2.add(Duration(days: 1)));
                  _calendarAgendaControllerAppBar2
                      .goToDay(Global.calendar_current_day2);
                }
              } else if (details.velocity.pixelsPerSecond.dx > 0) {
                if (isfront) {
                  hItems(
                      Global.calendar_current_day.subtract(Duration(days: 1)));
                  _calendarAgendaControllerAppBar
                      .goToDay(Global.calendar_current_day);
                } else {
                  hItems(
                      Global.calendar_current_day2.subtract(Duration(days: 1)));
                  _calendarAgendaControllerAppBar2
                      .goToDay(Global.calendar_current_day2);
                }
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
          child: side(isfront)),
    );
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
                  child: BottomSheetBar(
                      controller: bottomSheetBarController,
                      color: //透明
                          Colors.white,
                      isDismissable: false,
                      locked: false,
                      height: Global.bottombarheight,
                      expandedBuilder: (scrollController) {
                        return QRCode();
                      },
                      collapsed: SalomonBottomBar(
                        currentIndex: 0,
                        onTap: (i) {
                          // setState(() => _currentIndex = i);
                        },
                        items: [
                          /// Home
                          SalomonBottomBarItem(
                            icon: Icon(Icons.home),
                            title: Text("此处上滑显示图书馆二维码"),
                            selectedColor: Global.home_currentcolor,
                          ),
                        ],
                      ),
                      body: flip.FlipCard(
                        key: cardKey,
                        flipOnTouch: false,

                        fill: flip.Fill
                            .fillBack, // Fill the back side of the card to make in the same size as the front.
                        direction: flip.FlipDirection.HORIZONTAL, // default
                        side: flip
                            .CardSide.FRONT, // The side to initially display.
                        front: flipContainer(true),
                        back: flipContainer(false),
                      )))))
    ]));
  }

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

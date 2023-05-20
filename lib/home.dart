import 'dart:async';
import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:muse_nepu_course/chatforgpt/chat_gpt.dart';
import 'package:muse_nepu_course/game/screens/welcome_screen.dart';
import 'package:muse_nepu_course/jpushs.dart';
import 'package:muse_nepu_course/login/chaoxinglogin.dart';
import 'package:muse_nepu_course/global.dart';
import 'package:muse_nepu_course/pingjiao/pingjiao.dart';
import 'package:muse_nepu_course/qingjia/qingjia.dart';
import 'package:muse_nepu_course/qrcode/qrcode.dart';
import 'package:muse_nepu_course/test.dart';
import 'package:muse_nepu_course/windowsfloat.dart';
import 'package:rive/rive.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'package:path_provider/path_provider.dart';
import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:timelines/timelines.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:window_manager/window_manager.dart';
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

List<Widget> dailycourse = [];
GlobalKey scoredetailbtn = GlobalKey();
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
GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
GlobalKey<SideMenuState> _endSideMenuKey = GlobalKey<SideMenuState>();
String title = '今日课程';

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

  String localversion = '';
  String _cancelTag = "";
  String _apkFilePath = "";
  String _currentDownloadStateCH = "当前下载状态：还未开始";
  var _currentIndex = 0;
  Widget home_body() {
    return dailycourse.length == 0
        ? Container(
            child: GestureDetector(
            // onTap: _onTap,
            child: ClickAnimation(),
          ))
        : Container(
            //padding靠左
            child: Scaffold(
              body: ListView(
                children: dailycourse,
              ),
            ),
          );
  }

  void updateappx() {
    getApplicationDocumentsDirectory().then((value) {
      var pathx = value;
      File file = new File(value.path + '/version.txt');
      file.exists().then((value) {
        if (value) {
          file.readAsString().then((value) {
            localversion = value.toString();
            var dio = Dio();
            dio
                .get(
                    'https://update-nepucouseupdate-bmgwsddxxl.cn-hongkong.fcapp.run/update')
                .then((value) {
              //截取json中的version
              String version = value.data[0]['version'];
              if (version.toString() !=
                  Global.version) if (version.toString() != localversion) {
                Dialogs.materialDialog(
                  color: Colors.white,
                  msg: '要下载吗?',
                  title: '有新版本啦,版本号是' +
                      version.toString() +
                      "\n" +
                      value.data[0]['descrption'],
                  lottieBuilder: Lottie.asset(
                    'assets/rockert-new.json',
                    fit: BoxFit.contain,
                  ),
                  context: context,
                  actions: [
                    IconButton(
                      onPressed: () {
                        //将版本号写入
                        file.writeAsString(version.toString());
                        //关闭
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.cancel_outlined),
                    ),
                    IconButton(
                      onPressed: () async {
                        //将版本号写入
                        file.writeAsString(version.toString());
                        Navigator.pop(context);

                        //下载
                        ProgressDialog pd = ProgressDialog(context: context);
                        pd.show(
                            max: 100,
                            msg: '准备下载更新...',
                            msgMaxLines: 5,
                            completed: Completed(
                              completedMsg: "下载完成!",
                              completedImage: AssetImage
                                  //加载gif
                                  ("assets/completed.gif"),
                              completionDelay: 2500,
                            ));
                        await EasyAppInstaller.instance.downloadAndInstallApk(
                          fileUrl: value.data[0]['link'],
                          fileDirectory: "updateApk",
                          fileName: "newApk.apk",
                          explainContent: "快去开启权限！！！",
                          onDownloadingListener: (progress) {
                            if (progress < 100) {
                              pd.update(
                                  value: progress.toInt(), msg: '安装包正在下载...');
                            } else {
                              pd.update(
                                  value: progress.toInt(), msg: '安装包下载完成...');
                            }
                          },
                          onCancelTagListener: (cancelTag) {
                            _cancelTag = cancelTag;
                          },
                        );
                      },
                      icon: Icon(Icons.check),
                    ),
                  ],
                );
              }
            });
          });
        } else {
          file.create();
          getApplicationDocumentsDirectory().then((value) {
            file.exists().then((value) {
              if (value) {
                file.readAsString().then((value) {
                  var dio = Dio();
                  dio
                      .get(
                          'https://update-nepucouseupdate-bmgwsddxxl.cn-hongkong.fcapp.run/update')
                      .then((value) {
                    String version = value.data[0]['version'];
                    print(value.toString());
                    if (version.toString() != Global.version) if (version
                            .toString() !=
                        localversion) {
                      Dialogs.materialDialog(
                        color: Colors.white,
                        msg: '要下载吗?',
                        title: '有新版本啦,版本号是' +
                            version.toString() +
                            "\n" +
                            value.data[0]['descrption'],
                        lottieBuilder: Lottie.asset(
                          'assets/rockert-new.json',
                          fit: BoxFit.contain,
                        ),
                        context: context,
                        actions: [
                          IconButton(
                            onPressed: () {
                              //将版本号写入
                              file.writeAsString(version.toString());
                              //关闭
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.cancel_outlined),
                          ),
                          IconButton(
                            onPressed: () async {
                              //将版本号写入
                              Navigator.pop(context);

                              //下载
                              ProgressDialog pd =
                                  ProgressDialog(context: context);
                              pd.show(
                                  max: 100,
                                  msg: '准备下载更新...',
                                  msgMaxLines: 5,
                                  completed: Completed(
                                    completedMsg: "下载完成!",
                                    completedImage: AssetImage
                                        //加载gif
                                        ("assets/completed.gif"),
                                    completionDelay: 2500,
                                  ));
                              await EasyAppInstaller.instance
                                  .downloadAndInstallApk(
                                fileUrl: value.data[0]['link'],
                                fileDirectory: "updateApk",
                                fileName: "newApk.apk",
                                explainContent: "快去开启权限！！！",
                                onDownloadingListener: (progress) {
                                  if (progress < 100) {
                                    pd.update(
                                        value: progress.toInt(),
                                        msg: '安装包正在下载...');
                                  } else {
                                    file.writeAsString(version.toString());

                                    pd.update(
                                        value: progress.toInt(),
                                        msg: '安装包下载完成...');
                                  }
                                },
                                onCancelTagListener: (cancelTag) {
                                  _cancelTag = cancelTag;
                                },
                              );
                            },
                            icon: Icon(Icons.check),
                          ),
                        ],
                      );
                    }
                  });
                });
              }
            });
          });
        }
      });
    });
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

  void initState() {
    Global.pureyzmset(false);
    // Global().getxuehao();
    bottomSheetBarController.addListener(() {
      if (bottomSheetBarController.isExpanded == true) {
        //如果是展开状态
        // setState(() {
        //   if (Global.locked == false) Global().getqr();
        //   Global.locked = true;
        // });
      } else {
        setState(() {
          Global.locked = false;
        });
      }
    });
    homecontext = context;

    getcolor();
    //getApplicationDocumentsDirectory()方法获取应用程序的文档目录
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
            Global().No_perception_login().then((value) async {
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
                    Global().isfirstread = true;
                    jpushs().uploadpushid();
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
          updateappx();
          xinshouyindao();
          shownotice();
        }
      });
    });
  }

  var homecontext;
  void deleteFile() {
    getApplicationDocumentsDirectory().then((value) {
      File file = new File(value.path + '/course.json');
      if (file.existsSync()) {
        file.deleteSync();
      }
      //删除score.json
      File file2 = new File(value.path + '/score.json');
      if (file2.existsSync()) {
        file2.deleteSync();
      }
      File file4 = new File(value.path + '/calanderagenda.txt');
      //判断文件是否存在
      if (file4.existsSync()) {
        file4.deleteSync();
      }
      File file5 = new File(value.path + '/account.txt');
      //判断文件是否存在
      if (file5.existsSync()) {
        file5.deleteSync();
      }
    });
  }

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
      //判断响应状态
      Response response = await dio.get(url);
      if (response.statusCode == 500) {
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
          //获取下载进度并将进度设置为标题
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
      //下载完成后调用hitems
    });
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
    Global.calendar_current_day = date;
    await Global().loadItems(date);
    loadwidget(date);
  }

  Widget build(BuildContext context) {
    widthx = MediaQuery.of(context).size.width;

    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Container(
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
                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      home: QRCode(),
                    );
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
                  body: Scaffold(
                    appBar: CalendarAgenda(
                      controller: _calendarAgendaControllerAppBar,
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
                      events: [DateTime.now().subtract(Duration(days: 0))],
                      onDateSelected: (date) {
                        hItems(date);
                      },
                    ),
                    body: GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (!_isVerticalDrag) {
                          if (details.velocity.pixelsPerSecond.dx < 0) {
                            hItems(Global.calendar_current_day
                                .add(Duration(days: 1)));
                            _calendarAgendaControllerAppBar
                                .goToDay(Global.calendar_current_day);
                          } else if (details.velocity.pixelsPerSecond.dx > 0) {
                            hItems(Global.calendar_current_day
                                .subtract(Duration(days: 1)));
                            _calendarAgendaControllerAppBar
                                .goToDay(Global.calendar_current_day);
                          }
                        }
                      },
                      onVerticalDragStart: (details) {
                        _isVerticalDrag = true;
                        _dragStartPos = details.globalPosition;
                      },
                      onVerticalDragUpdate: (details) {
                        if (_isVerticalDrag) {
                          double dy =
                              details.globalPosition.dy - _dragStartPos.dy;
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
                      child: SideMenu(
                          background: Global.home_currentcolor,
                          key: _sideMenuKey,
                          menu: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(vertical: 50.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RiveAnimation.asset(
                                        'assets/cat.riv',
                                      ),
                                      SizedBox(height: 16.0),
                                      TextButton(
                                        onPressed: () =>
                                            Global().getrecently(context),
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
                                      Navigator.of(context).pop(); //关闭侧边栏

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  chat_gpt()));
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
                                    Navigator.of(context).pop(); //关闭侧边栏
                                    Global()
                                        .No_perception_login()
                                        .then((value) => null);
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
                                    Navigator.of(context).pop(); //关闭侧边栏
                                    Global()
                                        .No_perception_login()
                                        .then((value) => null);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => qingjia()));
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
                                                    pickerColor: Global
                                                        .home_currentcolor,
                                                    onColorChanged: changeColor,
                                                    colorPickerWidth: 300.0,
                                                    pickerAreaHeightPercent:
                                                        0.7,
                                                    enableAlpha: false,
                                                    displayThumbColor: true,
                                                    showLabel: true,
                                                    paletteType:
                                                        PaletteType.hsv,
                                                    pickerAreaBorderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          const Radius.circular(
                                                              2.0),
                                                      topRight:
                                                          const Radius.circular(
                                                              2.0),
                                                    ),
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('确定'),
                                                    onPressed: () async {
                                                      setState(() => Global
                                                              .home_currentcolor =
                                                          Global
                                                              .home_pickcolor);
                                                      getApplicationDocumentsDirectory()
                                                          .then((value) {
                                                        File file = File(
                                                            value.path +
                                                                '/color.txt');
                                                        //判断文件是否存在
                                                        if (file.existsSync()) {
                                                          //存在则写入
                                                          file.writeAsString(Global
                                                              .home_currentcolor
                                                              .value
                                                              .toString());
                                                        } else {
                                                          //不存在则创建文件并写入
                                                          file.createSync();
                                                          file.writeAsString(Global
                                                              .home_currentcolor
                                                              .value
                                                              .toString());
                                                        }
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
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
                                      '查看学习通已批完的考试但未发布的成绩',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop(); //关闭侧边栏

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  chaoxinglogin()));
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
                                    deleteFile();
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
                                      MaterialPageRoute(
                                          builder: (context) => about()),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
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
                                    leading: IconButton(
                                      icon: const Icon(Icons.menu),
                                      onPressed: () {
                                        toggleMenu();
                                      },
                                    ),
                                    actions: [
                                      IconButton(
                                        key: scoredetailbtn,
                                        icon: Icon(Icons.score),
                                        onPressed: () {
                                          if (isdownload) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      scorepage()),
                                            );
                                          } else {
                                            AchievementView(context,
                                                title: "出错啦!",
                                                subTitle:
                                                    '请确认现在是否学校在抢课或其他原因导致成绩下载超时',
                                                //onTab: _onTabAchievement,
                                                icon: Icon(
                                                  Icons.error,
                                                  color: Colors.white,
                                                ),
                                                //typeAnimationContent: AnimationTypeAchievement.fadeSlideToUp,
                                                //borderRadius: 5.0,
                                                color: Colors.red,
                                                //textStyleTitle: TextStyle(),
                                                //textStyleSubTitle: TextStyle(),
                                                //alignment: Alignment.topCenter,
                                                duration: Duration(seconds: 3),
                                                isCircle: true,
                                                listener: (status) {
                                              print(status);
                                            })
                                              ..show();
                                          }
                                        },
                                      ),
                                    ]),
                                body: dailycourse.length == 0
                                    ? Container(
                                        child: ClickAnimation(),
                                      )
                                    : Container(
                                        //padding靠左
                                        child: Scaffold(
                                          body: ListView(
                                            children: dailycourse,
                                          ),
                                        ),
                                      ),
                                floatingActionButton: Stack(children: [
                                  Positioned(
                                    bottom: 20.0,
                                    right: 10.0,
                                    child: MaterialButton(
                                      onPressed: () {},
                                      child: Text(
                                        '回到今天',
                                      ),
                                      shape: StadiumBorder(),
                                      textColor: Colors.white,
                                      color: Global.home_currentcolor,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _controller = SimpleAnimation('起飞');
                                      Future.delayed(Duration(seconds: 2), () {
                                        _controller = SimpleAnimation('保持飞翔');
                                        _controller = SimpleAnimation('降落');
                                        Future.delayed(Duration(seconds: 2),
                                            () {
                                          _controller = SimpleAnimation('行走');
                                        });
                                      });
                                      hItems(DateTime.now());
                                      setState(() {
                                        print('回到今天');
                                        _calendarAgendaControllerAppBar
                                            .goToDay(DateTime.now());
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.13,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.13,
                                      child: RiveAnimation.asset(
                                        'assets/birds.riv',
                                        controllers: [_controller],
                                        animations: ['行走', '起飞', '保持飞翔', '降落'],
                                      ),
                                    ),
                                  ),
                                ]),
                              ))),
                    ),
                  ),
                ),
              ),
            ),
          )
        ]),
      ),
    );
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

getcardpng() async {
  //获取应用目录的card.png，如果有则返回
  await getApplicationDocumentsDirectory().then((value) {
    File file = File(value.path + '/card.png');
    if (file.existsSync()) {
      //将本地图片保存到cardpic
      //将file转换为image
      cardpic = Image.file(File(file.path)).image;
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

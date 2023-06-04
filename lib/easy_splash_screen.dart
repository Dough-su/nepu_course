library easy_splash_screen;

import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:muse_nepu_course/global.dart';
import 'package:muse_nepu_course/login/login.dart';
import 'package:muse_nepu_course/progress.dart';
import 'package:muse_nepu_course/service/api_service.dart';
import 'package:path_provider/path_provider.dart';

class EasySplashScreen extends StatefulWidget {
  /// App title, shown in the middle of screen in case of no image available
  final Text? title;

  /// Page background color
  final Color backgroundColor;

  ///  Background image for the entire screen
  final ImageProvider? backgroundImage;

  /// logo width as in radius
  final double logoWidth;

  /// Main image mainly used for logos and like that
  final Image logo;

  /// Loader color
  final Color loaderColor;

  /// Loading text
  final Text loadingText;

  /// Padding for long Loading text, default: EdgeInsets.all(0)
  final EdgeInsets loadingTextPadding;

  /// Background gradient for the entire screen
  final Gradient? gradientBackground;

  /// Whether to display a loader or not
  final bool showLoader;

  /// durationInSeconds to navigate after for time based navigation
  final int durationInSeconds;

  /// The page where you want to navigate if you have chosen time based navigation
  /// String or Widget
  final dynamic navigator;
  //增加方法
  final Function? page;

  /// expects a function that returns a future, when this future is returned it will navigate
  /// Future<String> or Future<Widget>
  /// If both futureNavigator and navigator are provided, futureNavigator will take priority
  final Future<Object>? futureNavigator;

  EasySplashScreen({
    this.loaderColor = Colors.black,
    this.futureNavigator,
    this.navigator,
    this.durationInSeconds = 3,
    required this.logo,
    this.logoWidth = 50,
    this.title,
    this.backgroundColor = Colors.white,
    this.loadingText = const Text(''),
    this.loadingTextPadding = const EdgeInsets.only(top: 10.0),
    this.backgroundImage,
    this.gradientBackground,
    this.showLoader = true,
    this.page,
  });

  @override
  _EasySplashScreenState createState() => _EasySplashScreenState();
}

class _EasySplashScreenState extends State<EasySplashScreen> {
  //倒计时5s
  int _countdownTime = 1;
  String timetext() {
    if (_countdownTime <= 0) {
      setState(() {});
      return '跳过|0s';
    } else {
      setState(() {});
      return '跳过|$_countdownTime s';
    }
  }

  //倒计时5s
  void _countdownTimer() {
    const oneSec = const Duration(seconds: 1);
    var callback = (timer) => {
          setState(() {
            if (_countdownTime < 1) {
              timer.cancel();
              setState(() {});
            } else {
              print(_countdownTime);
              _countdownTime = _countdownTime - 1;
              setState(() {});
            }
          })
        };
    Timer.periodic(oneSec, callback);
  }

  @override
  void initState() {
    super.initState();
    Global().getaccount();
    Global().getusername();

    _countdownTimer();
    //获取主页和成绩页面的成绩信息
    Global.get_course_day();
    Global.get_course_day2();
    Global().readislogin2();
    Global().score_getcolor();
    //读取一卡通的账号
    Global.getcalendar();
    Global.getcalendar2();
    ApiService().getQr();

    Global().home_getcolor();
    Global().deletepj();
    Global().getlist();
    Global().getlist2();
    bool progressorhome = false;
    getApplicationDocumentsDirectory().then((value) {
      //判断是否有fist.txt文件,没有则创建，有则调用isfirst方法
      File file = new File(value.path + '/first.txt');
      file.exists().then((value) async {
        if (value) {
          progressorhome = true;
        }
      });
    });
    if (widget.futureNavigator == null) {
      Timer(Duration(seconds: widget.durationInSeconds), () {
        getApplicationDocumentsDirectory().then((value) {
          //判断是否有fist.txt文件,没有则创建，有则调用isfirst方法
          File file = new File(value.path + '/first.txt');
          file.exists().then((value) async {
            if (!progressorhome) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => WithBuilder()));
            } else {
              Global().isFirst(context);
            }
          });
        });
      });
    } else {
      widget.futureNavigator!.then((_route) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          //在屏幕右上角加入跳过

          Container(
            decoration: BoxDecoration(
              image: widget.backgroundImage != null
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: widget.backgroundImage!,
                    )
                  : null,
              gradient: widget.gradientBackground,
              color: widget.backgroundColor,
            ),
          ),
          Positioned(
            top: 30,
            right: 10,
            child: GestureDetector(
              onTap: () {
                getApplicationDocumentsDirectory().then((value) {
                  //判断是否有fist.txt文件,没有则创建，有则调用isfirst方法
                  File file = new File(value.path + '/first.txt');
                  file.exists().then((value) async {
                    if (!value) {
                      print('第一次启动');
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WithBuilder()));
                    } else {
                      Global().isFirst(context);
                    }
                  });
                });
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  timetext(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: widget.logo,
                          radius: widget.logoWidth,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                        ),
                        if (widget.title != null) widget.title!
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(bottom: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      widget.showLoader
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color?>(
                                widget.loaderColor,
                              ),
                            )
                          : Container(),
                      if (widget.loadingText.data!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                      Padding(
                        padding: widget.loadingTextPadding,
                        child: widget.loadingText,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

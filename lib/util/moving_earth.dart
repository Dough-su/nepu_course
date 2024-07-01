import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:muse_nepu_course/util/EarthAnimation.dart';
import 'package:muse_nepu_course/util/global.dart';
import 'package:path_provider/path_provider.dart';

import '../controller/LoginController.dart';
import 'package:get/get.dart';

class MovingEarth extends StatefulWidget {
  const MovingEarth({
    super.key,
    required this.child,
    required this.animatePosition,
    required this.durationInMs,
    required this.delayInMs,
  });

  final Widget child;
  final EarthAnimation animatePosition;
  final int durationInMs, delayInMs;

  @override
  State<MovingEarth> createState() => _MovingEarthState();
}

class _MovingEarthState extends State<MovingEarth> {
  final LoginController loginController = Get.put(LoginController());
  bool? animate;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // 启动登录过程
    Future.delayed(Duration.zero, () async {
      await Global().getusername();

      await loginAttempt();
    });

    // 获取主页和成绩页面的成绩信息
    Global.get_course_day();
    Global().score_getcolor();
    Global.getcalendar();
    Global().home_getcolor();
    Global().getlist();
    Global.getdesktop_float();

    // 加载文件信息
    _loadFileData();

    // 启动定时器，定时检查登录状态
    _startLoginCheckTimer();

    changeAnimation();
  }

  Future<void> loginAttempt() async {
    try {
      await loginController.noPerceptionLogin();
    } catch (e) {
      print("登录失败: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _loadFileData() {
    getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/course.json');
      file.exists().then((value) {
        if (!mounted) return;
        setState(() {
          Global.isfirst = !value;
        });
      });
    });

    getApplicationDocumentsDirectory().then((value) {
      // 判断是否有fist.txt文件, 没有则创建，有则调用isfirst方法
      File file = File(value.path + '/first.txt');
      file.exists().then((value) async {
        if (!mounted) return;
        if (value) {
          setState(() {
            Global.progressorhome = true;
          });
        }
      });
    });
  }

  void _startLoginCheckTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (loginController.jwc_jsessionid.value.isNotEmpty &&
          loginController.jwc_webvpn_key.value.isNotEmpty &&
          loginController.jwc_webvpn_username.value.isNotEmpty) {
        timer.cancel(); // 获取到数据后，停止定时器
        Global().jump_page(context); // 进行跳转
      }
      //或者登录失败也直接跳转
      if (!loginController.login_status.value) {
        timer.cancel(); // 获取到数据后，停止定时器
        Global().jump_page(context); // 进行跳转
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: widget.durationInMs),
      curve: Curves.easeInOut,
      top: animate!
          ? widget.animatePosition.topAfter
          : widget.animatePosition.topBefore,
      left: animate!
          ? widget.animatePosition.leftAfter
          : widget.animatePosition.leftBefore,
      bottom: animate!
          ? widget.animatePosition.bottomAfter
          : widget.animatePosition.bottomBefore,
      right: animate!
          ? widget.animatePosition.rightAfter
          : widget.animatePosition.rightBefore,
      child: widget.child,
    );
  }

  Future changeAnimation() async {
    animate = false;
    await Future.delayed(Duration(milliseconds: widget.delayInMs));
    if (mounted) {
      setState(() {
        animate = true;
      });
    }
  }
}
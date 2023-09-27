import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:muse_nepu_course/page/ProgressPage.dart';
import 'package:muse_nepu_course/util/EarthAnimation.dart';
import 'package:muse_nepu_course/util/global.dart';
import 'package:path_provider/path_provider.dart';

class MovingEarth extends StatefulWidget {
  const MovingEarth(
      {super.key,
      required this.child,
      required this.animatePosition,
      required this.durationInMs,
      required this.delayInMs});
  final Widget child;
  final EarthAnimation animatePosition;
  final int durationInMs, delayInMs;

  @override
  State<MovingEarth> createState() => _MovingEarthState();
}

class _MovingEarthState extends State<MovingEarth> {
  bool? animate;





  //倒计时
  void durationInSecondsr() {
    const oneSec = const Duration(seconds: 1);
    var callback = (timer) => {
          setState(() {
            if (Global.durationInSeconds < 1) {
              timer.cancel();
              setState(() {});
            } else {
              print(Global.durationInSeconds);
              Global.durationInSeconds = Global.durationInSeconds - 1;
              setState(() {});
            }
          })
        };
    Timer.periodic(oneSec, callback);
  }

  @override
  void initState() {
    durationInSecondsr();

    super.initState();
    Global().getusername();
    //获取主页和成绩页面的成绩信息
    Global.get_course_day();
    Global().score_getcolor();
    Global.getcalendar();
    Global().home_getcolor();
    Global().getlist();
    Global.getdesktop_float();
    getApplicationDocumentsDirectory().then((value) {
      File file = new File(value.path + '/course.json');
      file.exists().then((value) {
        Global.isfirst = !value;
      });
    });
    getApplicationDocumentsDirectory().then((value) {
      //判断是否有fist.txt文件,没有则创建，有则调用isfirst方法
      File file = new File(value.path + '/first.txt');
      file.exists().then((value) async {
        if (value) {
          Global.progressorhome = true;
        }
      });
    });

    Timer(Duration(seconds: Global.durationInSeconds), () {
      Global().jump_page(context);
    });

    super.initState();
    changeAnimation();
  }

  @override
  void dispose() {
    super.dispose();
    
  }

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

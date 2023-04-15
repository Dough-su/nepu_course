import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:muse_nepu_course/global.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:slide_countdown/slide_countdown.dart';

class QRCode extends StatefulWidget {
  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  int _countdownTime = 50;

  final streamDuration = StreamDuration(Duration(seconds: 50));

  void initState() {
    super.initState();
    Global().getqr();
    // _countdownTimer();
  }

  String endtime = '还有55s';
  //定时器50s,每50s刷新一次二维码，每1s刷新一次endtime
  // void _countdownTimer() {
  //   const oneSec = const Duration(seconds: 1);
  //   var callback = (timer) => {
  //         setState(() {
  //           if (_countdownTime < 1) {
  //             //刷新二维码并重置endtime
  //             Global().getqr();
  //             _countdownTime = 50;
  //             streamDuration.change(Duration(seconds: 51));

  //             setState(() {});
  //           } else {
  //             print(_countdownTime);
  //             _countdownTime = _countdownTime - 1;
  //             endtime = '还有$_countdownTime s' + Global.qrcode + '\n点击立即刷新';
  //             setState(() {});
  //           }
  //         })
  //       };
  //   Timer.periodic(oneSec, callback);
  // }

  //获取endtime
  String getendtime() {
    return endtime;
  }

  String passtemp = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Global.home_currentcolor,
          //设置
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                //弹窗一个文本框加上一个确认框
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("修改你的一卡通密码\n如果没有错误请不要修改"),
                        content: TextField(
                          onChanged: (value) {
                            passtemp = value;
                          },
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text("确认"),
                            onPressed: () {
                              Global.password = passtemp;
                              Global.saveaccount();
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    });
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('点击二维码可手动刷新\n当前是' + Global.qrcode),
            Align(
              alignment: Alignment.topCenter,
              child: SlideCountdown(
                decoration: BoxDecoration(
                    color: Global.home_currentcolor,
                    borderRadius: BorderRadius.circular(10)),
                durationTitle: DurationTitle(
                    days: "天", hours: "时", minutes: "分", seconds: "秒"),
                // This duration no effect if you customize stream duration
                streamDuration: streamDuration,
                onChanged: (Duration remaining) {
                  print("剩余" + remaining.inSeconds.toString()); //这里可以获取到剩余时间
                  //如果剩余时间等于1,恢复倒计时为50s
                  if (remaining.inSeconds <= 1) {
                    streamDuration.change(Duration(seconds: 51));
                    Global().getqr();
                    _countdownTime = 50;
                    setState(() {});
                  }
                },
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Global().getqr();
                  streamDuration.change(Duration(seconds: 51));
                  _countdownTime = 50;
                  setState(() {});
                },
                child: PrettyQr(
                  typeNumber: 3,
                  size: 200,
                  data: Global.qrcodegetter(),
                  errorCorrectLevel: QrErrorCorrectLevel.M,
                  roundEdges: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:muse_nepu_course/global.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QRCode extends StatefulWidget {
  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  void initState() {
    super.initState();
    _countdownTimer();
  }

  String endtime = '还有55s';
  int _countdownTime = 50;
  //定时器50s,每50s刷新一次二维码，每1s刷新一次endtime
  void _countdownTimer() {
    const oneSec = const Duration(seconds: 1);
    var callback = (timer) => {
          setState(() {
            if (_countdownTime < 1) {
              //刷新二维码并重置endtime
              Global().getqr();
              _countdownTime = 50;
              setState(() {});
            } else {
              print(_countdownTime);
              _countdownTime = _countdownTime - 1;
              endtime = '还有$_countdownTime s' + Global.qrcode;
              setState(() {});
            }
          })
        };
    Timer.periodic(oneSec, callback);
  }

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
        title: Text(getendtime()),
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
      body: Center(
        child: GestureDetector(
          onTap: () {
            Global().getqr();
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
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:muse_nepu_course/global.dart';
import 'package:muse_nepu_course/service/api_service.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:slide_countdown/slide_countdown.dart';

class QRCode extends StatefulWidget {
  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  final streamDuration = StreamDuration(Duration(seconds: 50));
  @override
  void initState() {
    super.initState();
    ApiService().getQr();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Global.home_currentcolor,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: _showDialog,
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('点击二维码可手动刷新\n当前是 ${Global.qrcode}'),
            Align(
              alignment: Alignment.topCenter,
              child: SlideCountdown(
                decoration: _buildDecoration(),
                durationTitle: DurationTitle(
                  days: "天",
                  hours: "时",
                  minutes: "分",
                  seconds: "秒",
                ),
                streamDuration: streamDuration,
                onChanged: (Duration remaining) {
                  if (remaining.inSeconds <= 1) {
                    streamDuration.change(Duration(seconds: 51));
                    ApiService().getQr().then((value) {
                      setState(() {});
                    });
                  }
                },
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  ApiService().getQr().then((value) {
                    streamDuration.change(Duration(seconds: 51));
                    setState(() {});
                  });
                },
                child: _buildQrCode(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("修改你的一卡通密码\n如果没有错误请不要修改"),
          content: TextField(
            onChanged: (value) {
              Global.password = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("确认"),
              onPressed: () {
                Global.saveaccount();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: Global.home_currentcolor,
      borderRadius: BorderRadius.circular(10),
    );
  }

  Widget _buildQrCode() {
    return PrettyQr(
      typeNumber: 3,
      size: 200,
      data: Global.qrcodegetter(),
      errorCorrectLevel: QrErrorCorrectLevel.M,
      roundEdges: true,
    );
  }
}

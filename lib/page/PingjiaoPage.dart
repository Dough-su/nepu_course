import 'dart:convert';
import 'package:achievement_view/achievement_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart' hide Response;
import 'package:muse_nepu_course/util/global.dart';
import 'package:card_loading/card_loading.dart';

import '../controller/LoginController.dart';

class Pingjiao extends StatefulWidget {
  @override
  _PingjiaoState createState() => _PingjiaoState();
}

int isFirst = 1;
double pingjiaoHighMark = 95;
double pingjiaoLowMark = 20;
List<dynamic> pingjiaoInfo = [];

class _PingjiaoState extends State<Pingjiao> {
  List<Widget> pingjiaoWidget = List.generate(
    5,
        (index) => CardLoading(
      height: 40,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      margin: EdgeInsets.only(bottom: 10),
    ),
  );

  TextEditingController highMarkController =
  TextEditingController(text: pingjiaoHighMark.toString());
  TextEditingController lowMarkController =
  TextEditingController(text: pingjiaoLowMark.toString());
  final LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    Global.bottombarheight = 60;
    downApkFunction();
  }

  Future<void> downApkFunction() async {
    var dio = Dio();
    var urlPingjiao =
        'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/getpingjiao' +
            await loginController.getCookies();
    print(urlPingjiao);
    try {
      Response response = await dio.get(urlPingjiao);
      pingjiaoInfo = json.decode(response.data);
      loadPingjiao();
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadPingjiao() async {
    pingjiaoWidget.clear();
    for (int i = 0; i < pingjiaoInfo.length; i++) {
      var urlPingjiao =
          'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/savepingjiao' +
              await loginController.getCookies() +
              "&xnxqdm=${pingjiaoInfo[i]['xnxqdm']}" +
              "&pjlxdm=${pingjiaoInfo[i]['pjlxdm']}" +
              "&teadm=${pingjiaoInfo[i]['teadm']}" +
              "&teabh=${pingjiaoInfo[i]['teabh']}" +
              "&teaxm=${pingjiaoInfo[i]['teaxm']}" +
              "&wjdm=${pingjiaoInfo[i]['wjdm']}" +
              "&kcrwdm=${pingjiaoInfo[i]['kcrwdm']}" +
              "&kcptdm=${pingjiaoInfo[i]['kcptdm']}" +
              "&kcdm=${pingjiaoInfo[i]['kcdm']}" +
              "&dgksdm=${pingjiaoInfo[i]['dgksdm']}" +
              "&jxhjdm=${pingjiaoInfo[i]['jxhjdm']}" +
              "&xnxqdm=${pingjiaoInfo[i]['xnxqdm']}";

      pingjiaoWidget.add(Slidable(
        key: UniqueKey(),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () async {
            var response = await Dio()
                .get(urlPingjiao + "&wtpf=" + pingjiaoHighMark.toString());
            var message = response.data['message'].toString();
            showAchievementView(message);
            setState(() => pingjiaoInfo.removeAt(i));
          }),
          children: [
            SlidableAction(
              onPressed: (BuildContext) => showAchievementView('继续滑啊'),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.archive,
              label: '继续滑动评价高分',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () async {
            var response = await Dio()
                .get(urlPingjiao + "&wtpf=" + pingjiaoLowMark.toString());
            var message = response.data['message'].toString();
            showAchievementView(message);
            setState(() => pingjiaoInfo.removeAt(i));
          }),
          children: [
            SlidableAction(
              onPressed: (BuildContext) => showAchievementView('继续滑啊'),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.archive,
              label: '继续滑动评价低分',
            ),
          ],
        ),
        child: ListTile(
          title: Text('${pingjiaoInfo[i]['teaxm']}---${pingjiaoInfo[i]['kcmc']}'),
        ),
      ));
    }
    setState(() {});
  }

  void showAchievementView(String message) {
    AchievementView(
      title: "hi!",
      subTitle: message,
      icon: Icon(
        Icons.emoji_emotions,
        color: Colors.white,
      ),
      color: Colors.green,
      duration: Duration(seconds: 3),
      isCircle: true,
      listener: (status) {
        print(status);
      },
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('设置高分和低分'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: highMarkController,
                        decoration:
                        InputDecoration(labelText: '高分，必须至少得有小数点后一位'),
                      ),
                      TextField(
                        controller: lowMarkController,
                        decoration:
                        InputDecoration(labelText: '低分,必须至少得有小数点后一位'),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: Text('取消'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: Text('确定'),
                      onPressed: () {
                        pingjiaoHighMark =
                            double.parse(highMarkController.text);
                        pingjiaoLowMark = double.parse(lowMarkController.text);
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            pingjiaoInfo.clear();
            Navigator.pop(context);
          },
        ),
        title: Text('评教,右滑高分，左滑低分'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(children: pingjiaoWidget),
          ),
        ),
      ),
    );
  }
}
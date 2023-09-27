import 'dart:convert';

import 'package:achievement_view/achievement_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:muse_nepu_course/util/global.dart';
import 'package:muse_nepu_course/service/api_service.dart';
import 'package:card_loading/card_loading.dart';

class pingjiao extends StatefulWidget {
  @override
  _pingjiaoState createState() => _pingjiaoState();
}

int isfirst = 1;
double pingjiaohighmark = 95;
double pingjiaolowmark = 20;
List<dynamic> pingjiaoinfo = [];

class _pingjiaoState extends State<pingjiao> {
  List<Widget> pingjiaowidget = [
    CardLoading(
      height: 40,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      margin: EdgeInsets.only(bottom: 10),
    ),
    CardLoading(
      height: 40,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      margin: EdgeInsets.only(bottom: 10),
    ),
    CardLoading(
      height: 40,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      margin: EdgeInsets.only(bottom: 10),
    ),
    CardLoading(
      height: 40,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      margin: EdgeInsets.only(bottom: 10),
    ),
    CardLoading(
      height: 40,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      margin: EdgeInsets.only(bottom: 10),
    ),
  ];
  //定义一个highmarkcontroller,来获取输入框的内容
  TextEditingController highmarkcontroller =
      TextEditingController(text: pingjiaohighmark.toString() //获取输入框的内容

          );
  TextEditingController lowmarkcontroller =
      TextEditingController(text: pingjiaolowmark.toString() //获取输入框的内容

          );
  Widget returnpingjiaowidget() {
    return ListView(children: pingjiaowidget);
  }

  void downApkFunction() async {
    var dio = Dio();

    //下载评教
    var urlpingjiao =
        'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/getpingjiao' +
            await Global().getLoginInfo();
    print(urlpingjiao);
    try {
      Response response = await dio.get(urlpingjiao);
      pingjiaoinfo = json.decode(response.data);
      loadpingjiao();
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    super.initState();
    Global.pureyzmset(false);
    Global.bottombarheight = 60;

    ApiService.noPerceptionLogin().then((value) async {
      downApkFunction();
    });
  }

  void loadpingjiao() async {
    pingjiaowidget.clear();
    for (int i = 0; i < pingjiaoinfo.length; i++) {
      var urlpingjiao =
          'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/savepingjiao' +
              await Global().getLoginInfo() +
              "&xnxqdm=" +
              pingjiaoinfo[i]['xnxqdm'] +
              "&pjlxdm=" +
              pingjiaoinfo[i]['pjlxdm'] +
              "&teadm=" +
              pingjiaoinfo[i]['teadm'] +
              "&teabh=" +
              pingjiaoinfo[i]['teabh'] +
              "&teaxm=" +
              pingjiaoinfo[i]['teaxm'] +
              "&wjdm=" +
              pingjiaoinfo[i]['wjdm'] +
              "&kcrwdm=" +
              pingjiaoinfo[i]['kcrwdm'] +
              "&kcptdm=" +
              pingjiaoinfo[i]['kcptdm'] +
              "&kcdm=" +
              pingjiaoinfo[i]['kcdm'] +
              "&dgksdm=" +
              pingjiaoinfo[i]['dgksdm'] +
              "&jxhjdm=" +
              pingjiaoinfo[i]['jxhjdm'] +
              "&xnxqdm=" +
              pingjiaoinfo[i]['xnxqdm'];

      pingjiaowidget.add(Slidable(
        key: UniqueKey(),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () async {
            var response = await Dio()
                .get(urlpingjiao + "&wtpf=" + pingjiaohighmark.toString());
            var message = response.data['message'].toString();
            showAchievementView(message);
            setState(() => pingjiaoinfo.removeAt(i));
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
                .get(urlpingjiao + "&wtpf=" + pingjiaolowmark.toString());
            var message = response.data['message'].toString();
            showAchievementView(message);
            setState(() => pingjiaoinfo.removeAt(i));
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
          title:
              Text(pingjiaoinfo[i]['teaxm'] + '---' + pingjiaoinfo[i]['kcmc']),
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
        isCircle: true, listener: (status) {
      print(status);
    })
      ..show(context);
  }

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
                        controller: highmarkcontroller,
                        decoration:
                            InputDecoration(labelText: '高分，必须至少得有小数点后一位'),
                      ),
                      TextField(
                        controller: lowmarkcontroller,
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
                        pingjiaohighmark =
                            double.parse(highmarkcontroller.text);
                        pingjiaolowmark = double.parse(lowmarkcontroller.text);
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
            pingjiaoinfo.clear();
            Navigator.pop(context);
          },
        ),
        title: Text('评教,右滑高分，左滑低分'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(children: pingjiaowidget),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:achievement_view/achievement_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:muse_nepu_course/util/global.dart';
import 'package:muse_nepu_course/service/api_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:card_loading/card_loading.dart';

class qingjia extends StatefulWidget {
  @override
  _qingjiaState createState() => _qingjiaState();
}

int isfirst = 1;
double qingjiahighmark = 95;
double qingjialowmark = 20;

class _qingjiaState extends State<qingjia> {
  List<Widget> qingjiawidget = [
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
//读取下载的json
  Future<String> getqingjiaoInfo() async {
    //获取路径
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/qingjia.json';
    //读取文件
    File file = new File(path);
    String qingjiaInfo = await file.readAsString();
    return qingjiaInfo;
  }


  void initState() {
    super.initState();
    Global.pureyzmset(false);
    Global.bottombarheight = 60;

    ApiService.noPerceptionLogin().then((value) async {
      ApiService().qinajia(context,loadqingjia);
    });
  }

  void loadqingjia() async {
    var dio = Dio();

    var qingjiainfo;
    getqingjiaoInfo().then((value) {
      qingjiainfo = json.decode(value);
      qingjiawidget.clear();
      for (int i = 0; i < qingjiainfo.length; i++) {
        qingjiawidget.add(Slidable(
            key: UniqueKey(),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(onDismissed: () async {
                var urlqingjia =
                    'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/delqingjia' +
                        await Global().getLoginInfo() +
                        "&sqdm=" +
                        qingjiainfo[i]['sqdm'];
                print(urlqingjia);
                //移除当前评教
                setState(() {
                  qingjiainfo.removeAt(i);
                });
                // //获取返回值
                var response = await dio.get(urlqingjia);
                try {
                  AchievementView(
                      title: "hi!",
                      subTitle: response.data.toString(),
                      //onTab: _onTabAchievement,
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
                } catch (Exception) {
                  AchievementView(
                      title: "hi!",
                      subTitle: '状态被改变',
                      //onTab: _onTabAchievement,
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
              }),
              children: [
                SlidableAction(
                  onPressed: (BuildContext) async {
                    AchievementView(
                        title: "点我干嘛？",
                        subTitle: '继续滑啊',
                        //onTab: _onTabAchievement,
                        icon: Icon(
                          Icons.emoji_emotions,
                          color: Colors.white,
                        ),
                        color: Colors.yellow,
                        duration: Duration(seconds: 3),
                        isCircle: true, listener: (status) {
                      print(status);
                    })
                      ..show(context);
                  },
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.archive,
                  label: '继续滑动改变状态',
                ),
              ],
            ),
            child: ListTile(
              title:
                  Text(qingjiainfo[i]['qsrq'] + '请假原因:' + qingjiainfo[i]['bz']),
            )));
      }
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //加入主页图标
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('请假历史'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(children: qingjiawidget),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

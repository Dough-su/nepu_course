import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:achievement_view/achievement_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:muse_nepu_course/global.dart';
import 'package:muse_nepu_course/home.dart';
import 'package:path_provider/path_provider.dart';
import 'package:card_loading/card_loading.dart';

class pingjiao extends StatefulWidget {
  @override
  _pingjiaoState createState() => _pingjiaoState();
}

int isfirst = 1;
double pingjiaohighmark = 95;
double pingjiaolowmark = 20;
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

class _pingjiaoState extends State<pingjiao> {
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

  @override

//读取下载的json
  Future<String> getpingjiaoInfo() async {
    //获取路径
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/pingjiao.json';
    //读取文件
    File file = new File(path);
    String pingjiaoInfo = await file.readAsString();
    return pingjiaoInfo;
  }

  void downApkFunction() async {
    var dio = Dio();

    //下载评教
    getApplicationDocumentsDirectory().then((value) async {
      var urlpingjiao =
          'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/getpingjiao' +
              await Global().getLoginInfo();
      print(urlpingjiao);
      getApplicationDocumentsDirectory().then((value) {
        dio.download(urlpingjiao, value.path + '/pingjiao.json',
            onReceiveProgress: (int count, int total) {
          setState(() {});
        }).then((value) async {
          loadpingjiao();
        });
      });
    });
  }

  void initState() {
    Global.pureyzmset(false);
    Global.bottombarheight = 60;

    Global().No_perception_login().then((value) async {
      downApkFunction();
    });
  }

  void loadpingjiao() async {
    var dio = Dio();

    var pingjiaoinfo;
    getpingjiaoInfo().then((value) {
      pingjiaoinfo = json.decode(value);
      pingjiaowidget.clear();
      for (int i = 0; i < pingjiaoinfo.length; i++) {
        pingjiaowidget.add(Slidable(
            key: UniqueKey(),
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(onDismissed: () async {
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
                        pingjiaoinfo[i]['xnxqdm'] +
                        "&wtpf=" +
                        pingjiaohighmark.toString();
                print(urlpingjiao);
                //移除当前评教
                setState(() {
                  pingjiaoinfo.removeAt(i);
                });
                // //获取返回值
                var response = await dio.get(urlpingjiao);
                try {
                  AchievementView(context,
                      title: "hi!",
                      subTitle: response.data['message'].toString(),
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
                    ..show();
                } catch (Exception) {
                  AchievementView(context,
                      title: "hi!",
                      subTitle: '评教成功',
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
                    ..show();
                }
              }),
              children: [
                SlidableAction(
                  onPressed: (BuildContext) async {
                    AchievementView(context,
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
                      ..show();
                  },
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
                        pingjiaoinfo[i]['xnxqdm'] +
                        "&wtpf=" +
                        pingjiaolowmark.toString();
                print(urlpingjiao);
                //移除当前评教
                setState(() {
                  pingjiaoinfo.removeAt(i);
                });
                // //获取返回值
                var response = await dio.get(urlpingjiao);
                try {
                  AchievementView(context,
                      title: "hi!",
                      subTitle: response.data['message'].toString(),
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
                    ..show();
                } catch (Exception) {
                  AchievementView(context,
                      title: "hi!",
                      subTitle: '评教成功',
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
                    ..show();
                }
              }),
              children: [
                SlidableAction(
                  onPressed: (BuildContext) async {
                    AchievementView(context,
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
                      ..show();
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.archive,
                  label: '继续滑动评价低分',
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                  pingjiaoinfo[i]['teaxm'] + '---' + pingjiaoinfo[i]['kcmc']),
            )));
      }
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        //支持暗黑模式
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: Scaffold(
          appBar: AppBar(
            //加入一个文字按钮，弹出框修改高分和低分
            actions: [
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('设置高分和低分'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: highmarkcontroller,
                                decoration: InputDecoration(
                                  labelText: '高分，必须至少得有小数点后一位',
                                ),
                              ),
                              TextField(
                                controller: lowmarkcontroller,
                                decoration: InputDecoration(
                                  labelText: '低分,必须至少得有小数点后一位',
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              child: Text('取消'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('确定'),
                              onPressed: () {
                                pingjiaohighmark =
                                    //转为double
                                    double.parse(highmarkcontroller.text);
                                print(pingjiaohighmark);
                                pingjiaolowmark =
                                    //转为double
                                    double.parse(lowmarkcontroller.text);
                                print(pingjiaolowmark);
                                setState(() {});
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                },
              ),
            ],
            //加入主页图标
            leading: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Global().deletepj();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
            title: Text('评教,右滑高分，左滑低分'),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(children: pingjiaowidget),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

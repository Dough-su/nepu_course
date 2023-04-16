import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:muse_nepu_course/global.dart';
import 'package:muse_nepu_course/home.dart';
import 'package:muse_nepu_course/login/chaoxinglogin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class chaoxing extends StatefulWidget {
  @override
  _chaoxingState createState() => _chaoxingState();
}

class _chaoxingState extends State<chaoxing> {
  List<Widget> listx = [];

  @override
  scorelist() {
    Global.bottombarheight = 60;

    //创建一个list
    getApplicationDocumentsDirectory().then((value) async {
      //读取chaoxing.txt
      var file = await new File(value.path + "/chaoxing.txt").readAsString();

      Dio dio = new Dio();
      ProgressDialog pd = ProgressDialog(context: context);
      pd.show(
          max: 100,
          msg: '服务器正在加工你的数据哦，不是卡住了，请稍等...',
          msgMaxLines: 5,
          completed: Completed(
            completedMsg: "下载完成!",
            completedImage: AssetImage
                //加载gif
                ("assets/completed.gif"),
            completionDelay: 2500,
          ));
      var response;
      response = await dio.get(
          "https://chaoxingpython-chaoxingpython-ystzjjdcxp.ap-southeast-1.fcapp.run/course?cookies=" +
              file.toString(), onReceiveProgress: (int count, int total) {
        int progress = (((count / total) * 100).toInt());
        pd.update(value: progress, msg: '久等了，数据正在下载...');
      }).then((value) async {
        var jsons = value.data;
        pd.close();

        //遍历json
        for (var i = 1; i < jsons.length; i++) {
          var zerotip = '';
          var fenshutip = '你的最终成绩';
          if (jsons[i]["score"] == '0' && jsons[i]["workMarked"] == 0)
            zerotip = '(这里的0分代表老师没有批阅哦)';
          if (jsons[i]["completeNum"] != 1 && jsons[i]["completeNum"] != 0)
            fenshutip = '你的' + jsons[i]["completeNum"].toString() + '次考试平均分是';
          if (jsons[i]["completeNum"] == 0) continue;
          var allexamlength = jsons[i]["allexam"].length;
          var allexam = "名字是" +
              jsons[i]["name"] +
              ",学号是" +
              jsons[i]["aliasName"] +
              "\n已提交考试:" +
              jsons[i]["workSubmited"].toString() +
              "/" +
              jsons[i]["completeNum"].toString() +
              "\n被批阅" +
              jsons[i]["workMarked"].toString() +
              "/" +
              jsons[i]["completeNum"].toString();

          for (var j = 0; j < allexamlength; j++) {
            allexam = allexam +
                '\n' +
                jsons[i]["allexam"][j]["title"] +
                '分数是' +
                jsons[i]["allexam"][j]["stuScore"].toString() +
                '分，满分是' +
                jsons[i]["allexam"][j]["totalScore"].toString() +
                '分';
          }
          //创建一个card
          var card = Card(
            child: Column(
              children: <Widget>[
                //加入ontap

                ListTile(
                    onTap: (() => Dialogs.materialDialog(
                          color: Colors.white,
                          msg: allexam,
                          customViewPosition: CustomViewPosition.BEFORE_MESSAGE,
                          title: '详细信息',
                          lottieBuilder: Lottie.asset(
                            'assets/check-mark.json',
                            fit: BoxFit.contain,
                          ),
                          context: context,
                        )),
                    title: Text(jsons[i]["coursename"]),
                    subtitle: Text(fenshutip +
                        jsons[i]["score"].toString() +
                        zerotip +
                        '\n点击查看详情')),
              ],
            ),
          );
          //将card加入list
          listx.add(card);
          setState(() {});
        }
      });
    });
  }

  void initState() {
    super.initState();
    //等待页面加载完成
    scorelist();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HomePage();
              }));
            },
          ),
          title: Text("成绩列表"),
          actions: [
            TextButton(
              child: Text(
                "重新登陆",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                //删除chaoxing.txt
                getApplicationDocumentsDirectory().then((value) async {
                  var file = await new File(value.path + "/chaoxing.txt");
                  file.delete();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => chaoxinglogin()),
                  );
                });
              },
            )
          ],
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: listx,
            ),
          ),
        ]),
      ),
    );
  }
}

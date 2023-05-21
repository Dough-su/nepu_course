import 'dart:io';
import 'package:achievement_view/achievement_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:muse_nepu_course/diffcult_flutter_refresh/easy_refresh.dart';
import 'package:muse_nepu_course/diffcult_flutter_refresh/src/styles/space/easy_refresh_space.dart';
import 'package:muse_nepu_course/global.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:card_flip/card_flip.dart';

ImageProvider cardpic = AssetImage('images/image.png');
ImageProvider avaterpic = AssetImage('images/avatar.png');

class scorepage extends StatefulWidget {
  @override
  _scoreState createState() => _scoreState();
}

Widget component1(fenshu, paiming, shijian, coursename, leixing, jidian) {
  //如果参数有null，就返回空

  double height = 200.0;
  return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, 0.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              Container(
                //距离上下边距
                // margin: const EdgeInsets.only(bottom: 20.0),
                width: 88,
                color: Global.score_currentcolor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      fenshu + '分',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(),
                        children: [
                          TextSpan(
                            text: '       学期',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                          TextSpan(
                            text: '    ' + shijian,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  height: double.infinity,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Image.asset(
                            'images/dots.png',
                            width: 16,
                            height: 42,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  coursename,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 8, 10, 8),
                                  width: double.infinity,
                                  height: 0.5,
                                  color: Colors.black,
                                ),
                                const Text(
                                  '点击查看详情',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          explainText('绩点', jidian),
                          explainText('排名', paiming),
                          explainText('类型', leixing),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ));
}

var avgmark = [];
var avgjidian = [];
String detailmsg = '';

class FoldCard extends StatelessWidget {
  String fenshu; //分数
  String paiming; //排名
  String shijian; //时间
  String coursename; //课程名
  String leixing; //课程类型
  String jidian; //绩点
  FoldCard(this.fenshu, this.paiming, this.shijian, this.coursename,
      this.leixing, this.jidian);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: component1(fenshu, paiming, shijian, coursename, leixing, jidian),
      onTap: () {
        FlipLayout.of(context).toggle();
      },
    );
  }
}

class _scoreState extends State<scorepage> {
  bool isfresh = false;

  refresh() {
    if (isfresh == false) {
      setState(() {
        isfresh = true;
      });
    }
  }

  List<Widget> list = [];

  String chengjidaima = '';

  int _count = 10;

  //存储获取到的新成绩信息
  Future saveString(easycontroller) async {
    Dio dio = Dio();

    var urlscore =
        'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/getnewscore' +
            await Global().getLoginInfo() +
            '&index=' +
            Global.scoreinfos[Global.scoreinfos.length - 1]['cjdm'].toString();
    print(urlscore);
    getApplicationDocumentsDirectory().then((value) async {
      try {
        Response response = await dio.get(urlscore);
        if (response.statusCode == 200) {
          //获取路径
          Directory directory = await getApplicationDocumentsDirectory();
          String path = directory.path + '/score.json';
          //追加文件
          File file = new File(path);
          file.readAsString().then((value) {
            value = value.replaceAll(']', '') +
                ',' +
                response.data.toString().replaceAll('[', '');
            file.writeAsString(value);
            Global().getlist();
          });
          AchievementView(context,
              title: "hi!",
              subTitle: '课程已更新，请重新进入该页面',
              color: Global.home_currentcolor,
              duration: Duration(seconds: 3),
              isCircle: true,
              listener: (status) {})
            ..show();
          easycontroller.finishRefresh();
        }
      } catch (e) {
        print(e);
        AchievementView(context,
            title: "hi!",
            subTitle: '课程已经都是最新了哦',
            color: Global.home_currentcolor,
            duration: Duration(seconds: 2),
            isCircle: true,
            listener: (status) {})
          ..show();
        easycontroller.finishRefresh();

        return;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void changeColor(Color color) {
    setState(() => Global.score_pickcolor = color);
  }

  void initState() {
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    Global.pureyzmset(false);
    getcardpngx();
    getavaterpngx();
    super.initState();
  }

  late EasyRefreshController _controller;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Global.score_currentcolor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: const Text('下拉获取新成绩'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.color_lens),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('选择当前页面主题颜色'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: Global.score_pickcolor,
                              onColorChanged: changeColor,
                              showLabel: true,
                              pickerAreaHeightPercent: 0.8,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('确定'),
                              onPressed: () {
                                setState(() => Global.score_currentcolor =
                                    Global.score_pickcolor);
                                getApplicationDocumentsDirectory()
                                    .then((value) {
                                  File file = File(value.path + '/color1.txt');
                                  //判断文件是否存在
                                  if (file.existsSync()) {
                                    //存在则写入
                                    file.writeAsString(Global
                                        .score_currentcolor.value
                                        .toString());
                                  } else {
                                    //不存在则创建文件并写入
                                    file.createSync();
                                    file.writeAsString(Global
                                        .score_currentcolor.value
                                        .toString());
                                  }
                                  Global().getlist();
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            body: EasyRefresh(
                controller: _controller,
                header: const SpaceHeader(),
                onRefresh: () async {
                  print('onfresh被调用了');

                  Global().No_perception_login().then((value) async {
                    print(Global().getLoginInfo());
                    saveString(_controller);
                  });
                  await Future.delayed(Duration(seconds: 100));

                  if (!mounted) {
                    return;
                  }
                  _count = 10;

                  _controller.resetFooter();
                },
                onLoad: () async {
                  print('onload被调用了');

                  await Future.delayed(const Duration(seconds: 4));
                  if (!mounted) {
                    return;
                  }

                  _count += 5;

                  _controller.finishLoad(1 >= 20
                      ? IndicatorResult.noMore
                      : IndicatorResult.success);
                },
                child: ListView.builder(
                    itemCount: Global.scorelist.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Global.scorelist[index],
                        ),
                      );
                    })

                // SingleChildScrollView(
                //   child: Center(

                //   ),
                )));
  }
}

/// 三行文字
Widget multipleLineText(String line1, String line2) {
  return Text.rich(
    TextSpan(
      style: const TextStyle(
        height: 1.4,
      ),
      children: [
        TextSpan(
          text: '$line1\n',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        TextSpan(
          text: '$line2\n',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}

///
Widget explainText(String title, String subtitle,
    {Color? titleColor, Color? subtitleColor}) {
  return Text.rich(
    TextSpan(
        style: const TextStyle(
          height: 1.4,
        ),
        children: [
          TextSpan(
              text: '$title\n',
              style: TextStyle(
                color: titleColor ?? Colors.grey,
                fontSize: 13,
              )),
          TextSpan(
            text: subtitle,
            style: TextStyle(
              color: subtitleColor ?? Colors.blueGrey,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ]),
  );
}

ImageProvider<Object> getcardpngx() {
  getcardpng();
  return cardpic;
}

getcardpng() async {
  //获取应用目录的card.png，如果有则返回
  await getApplicationDocumentsDirectory().then((value) {
    File file = File(value.path + '/card.png');
    if (file.existsSync()) {
      //将本地图片保存到cardpic
      //将file转换为image
      cardpic = Image.file(File(file.path)).image;
    }
  });
}

ImageProvider<Object> getavaterpngx() {
  getavaterpng();
  return avaterpic;
}

getavaterpng() async {
  //获取应用目录的card.png，如果有则返回
  await getApplicationDocumentsDirectory().then((value) {
    File file = File(value.path + '/avater.png');
    if (file.existsSync()) {
      //将本地图片保存到cardpic
      //将file转换为image
      avaterpic = Image.file(File(file.path)).image;
    }
  });
}

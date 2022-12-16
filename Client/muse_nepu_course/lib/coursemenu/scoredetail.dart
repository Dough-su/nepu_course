// import 'dart:convert';
// import 'dart:io';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:path_provider/path_provider.dart';

import '../score.dart';
import 'package:flutter/material.dart';

import 'package:card_flip/card_flip.dart';

Color pickerColor = Color.fromARGB(255, 73, 160, 230);
Color currentColor = Color.fromARGB(255, 73, 160, 230);
ImageProvider cardpic = AssetImage('images/image.png');
ImageProvider avaterpic = AssetImage('images/avatar.png');

class score extends StatefulWidget {
  @override
  _scoreState createState() => _scoreState();
}

Widget component1(fenshu, paiming, shijian, coursename, leixing, jidian) {
  //如果参数有null，就返回空

  double height = 200.0;
  return ClipRRect(
    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
    child: SizedBox(
      height: height,
      child: Row(
        children: [
          Container(
            //距离上下边距
            margin: const EdgeInsets.only(bottom: 20.0),
            width: 88,
            color: currentColor,
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
                          color: Colors.black,
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
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 8, 10, 8),
                              width: double.infinity,
                              height: 0.5,
                              color: Colors.grey[200],
                            ),
                            const Text(
                              '点击查看详情',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
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
  );
}

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

class _scoreState extends State<score> {
  //读取json
  Future<String> getscoreInfo() async {
    //获取路径
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/score.json';
    //读取文件
    File file = new File(path);
    String scoreInfo = await file.readAsString();
    return scoreInfo;
  }

  bool isfresh = false;

  refresh() {
    if (isfresh == false) {
      setState(() {
        isfresh = true;
      });
    }
  }

  List<Widget> list = [];
  List<Widget> getlist() {
    getscoreInfo().then((value) {
      var scoreInfo = json.decode(value);
      for (var i = 0; i < scoreInfo.length; i++) {
        //打印分数zcj
        //组件1
        list.add(FlipLayout(
          duration: 500,
          foldState: false,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 44,
                    color: currentColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        Text(
                          scoreInfo[i]['kcmc'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          scoreInfo[i]['zcj'] + '分',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Image(
                        image: getcardpngx(),
                        width: double.infinity,
                        height: 121,
                        fit: BoxFit.cover,
                      ),
                      Positioned.fill(
                        bottom: 12,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            explainText('绩点', scoreInfo[i]['cjjd'],
                                subtitleColor: Colors.white),
                            explainText(
                                '排名',
                                scoreInfo[i]['paiming'] +
                                    '/' +
                                    scoreInfo[i]['zongrenshu'],
                                subtitleColor: Colors.white),
                            explainText('类型', scoreInfo[i]['xdfsmc'],
                                subtitleColor: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8.0),
              ),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 6),
                      child: Text(
                        '姓名',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image(
                            image: getavaterpngx(),
                            width: 48,
                            height: 48,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              scoreInfo[i]['xsxm'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: const [
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  '加油哦',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                    Divider(
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: multipleLineText(
                        '小于60分有', scoreInfo[i]['fenshu60'] + '人'),
                  ),
                  Expanded(
                    child: multipleLineText(
                        '60-70分有', scoreInfo[i]['fenshu70'] + '人'),
                  ),
                  Expanded(
                    child: multipleLineText(
                        '70-80分有', scoreInfo[i]['fenshu80'] + '人'),
                  ),
                  Expanded(
                      child: multipleLineText(
                          '80-90分有', scoreInfo[i]['fenshu90'] + '人')),
                  Expanded(
                    child: multipleLineText(
                        '90-100分有', scoreInfo[i]['fenshu100'] + '人'),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                      child: multipleLineText('平时成绩', scoreInfo[i]['pscj'])),
                  Expanded(
                    child: multipleLineText('实验成绩', scoreInfo[i]['sycj']),
                  ),
                  Expanded(
                    child: multipleLineText('期中成绩', scoreInfo[i]['qzcj']),
                  ),
                  Expanded(
                    child: multipleLineText('期末成绩', scoreInfo[i]['qmcj']),
                  ),
                  Expanded(
                    child: multipleLineText('实践成绩', scoreInfo[i]['sjcj']),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(8)),
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Builder(builder: (context) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          primary: currentColor,
                        ),
                        onPressed: () {
                          FlipLayout.of(context).toggle();
                        },
                        child: const Text(
                          '收起',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text(' ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ))
                  ],
                ),
              ),
            ),
          ],
          foldChild: FoldCard(
              scoreInfo[i]['zcjfs'],
              scoreInfo[i]['paiming'] + '/' + scoreInfo[i]['zongrenshu'] + '',
              scoreInfo[i]['xnxqmc'],
              scoreInfo[i]['kcmc'],
              scoreInfo[i]['xdfsmc'],
              scoreInfo[i]['cjjd']),
        ));
      }
      refresh();
    });
    return list;
  }

  @override
  Future<void> getcolor() async {
    getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/color1.txt');
      if (file.existsSync()) {
        file.readAsString().then((value) {
          setState(() {
            currentColor = Color(int.parse(value));
            pickerColor = Color(int.parse(value));
          });
        });
      }
    });
    setState(() {});
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void initState() {
    getcolor();
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      //设置主题
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          //加入返回按钮
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('分数详情'),
          backgroundColor: currentColor,
          //加入选取颜色按钮
          actions: <Widget>[
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
                          pickerColor: pickerColor,
                          onColorChanged: changeColor,
                          showLabel: true,
                          pickerAreaHeightPercent: 0.8,
                        ),
                        // child: ColorPicker(
                        //   pickerColor: pickerColor,
                        //   onColorChanged: changeColor,
                        //   showLabel: true,
                        //   pickerAreaHeightPercent: 0.8,
                        // ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('确定'),
                          onPressed: () {
                            setState(() => currentColor = pickerColor);
                            getApplicationDocumentsDirectory().then((value) {
                              File file = File(value.path + '/color1.txt');
                              //判断文件是否存在
                              if (file.existsSync()) {
                                //存在则写入
                                file.writeAsString(
                                    currentColor.value.toString());
                              } else {
                                //不存在则创建文件并写入
                                file.createSync();
                                file.writeAsString(
                                    currentColor.value.toString());
                              }
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
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(children: getlist()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

Score _$ScoreFromJson(Map<String, dynamic> json) => Score(
      json['xsxm'] as String,
      json['zcjfs'] as String,
      json['xnxqmc'] as String,
      json['cjjd'] as String,
      json['kcmc'] as String,
      json['cjdm'] as String,
      json['zcj'] as String,
      json['wzc'] as String,
      json['kkbmmc'] as String,
      json['xf'] as String,
      json['zxs'] as String,
      json['xdfsmc'] as String,
      json['jxbmc'] as String,
      json['fenshu60'] as String,
      json['fenshu70'] as String,
      json['fenshu80'] as String,
      json['fenshu90'] as String,
      json['fenshu100'] as String,
      json['zongrenshu'] as String,
      json['paiming'] as String,
      json['cj1'] as String,
      json['cj2'] as String,
      json['cj3'] as String,
      json['cj4'] as String,
      json['cj5'] as String,
    );

Map<String, dynamic> _$ScoreToJson(Score instance) => <String, dynamic>{
      'xsxm': instance.xsxm,
      'zcjfs': instance.zcjfs,
      'xnxqmc': instance.xnxqmc,
      'cjjd': instance.cjjd,
      'kcmc': instance.kcmc,
      'cjdm': instance.cjdm,
      'zcj': instance.zcj,
      'wzc': instance.wzc,
      'kkbmmc': instance.kkbmmc,
      'xf': instance.xf,
      'zxs': instance.zxs,
      'xdfsmc': instance.xdfsmc,
      'jxbmc': instance.jxbmc,
      'fenshu60': instance.fenshu60,
      'fenshu70': instance.fenshu70,
      'fenshu80': instance.fenshu80,
      'fenshu90': instance.fenshu90,
      'fenshu100': instance.fenshu100,
      'zongrenshu': instance.zongrenshu,
      'paiming': instance.paiming,
      'cj1': instance.cj1,
      'cj2': instance.cj2,
      'cj3': instance.cj3,
      'cj4': instance.cj4,
      'cj5': instance.cj5,
    };
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
      print(file.path);
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
      print(file.path);
      avaterpic = Image.file(File(file.path)).image;
    }
  });
}

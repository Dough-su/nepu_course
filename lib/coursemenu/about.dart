import 'dart:io';

import 'package:achievement_view/achievement_view.dart';
import 'package:easy_app_installer/easy_app_installer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:muse_nepu_course/black_jack/screens/black_jack_screen.dart';
import 'package:muse_nepu_course/chess/bloc/app_blocs.dart';
import 'package:muse_nepu_course/chess/screens/game_screen.dart';
import 'package:muse_nepu_course/game/screens/welcome_screen.dart';
import 'package:muse_nepu_course/global.dart';
import 'package:muse_nepu_course/jpushs.dart';
import 'package:muse_nepu_course/wuziqi/wuziqi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class about extends StatefulWidget {
  @override
  _aboutState createState() => _aboutState();
}

var logourl = '';
final ImagePicker _picker = ImagePicker();

class _aboutState extends State<about> {
  //两个输入框
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();

    _usernameController.text = Global.jwc_xuehao;
    _passwordController.text = Global.jwc_password;
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
              Navigator.pop(context);
            },
          ),
          title: Text('关于&设置'),
        ),
        body: Center(
          //创建一个ListView展示五个头像
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.info),
                title: Text('关于'),
                subtitle: Text('身在井隅，心向璀璨。'),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('内部版本号'),
                subtitle: Text(Global.version),
              ),
              //切换课程自动更新开关
              ListTile(
                leading: Icon(Icons.info),
                title: Text('课程自动更新'),
                subtitle: Text('开启后，每次打开软件都会自动更新课程表。'),
                trailing: Switch(
                  onChanged: (value) {
                    setState(() {
                      Global.auto_update_course = value;
                      Global.saveauto_update_course();
                    });
                  },
                  value: Global.auto_update_course,
                ),
              ),
              //多版本下载网址，可以复制到剪切板
              ListTile(
                leading: Icon(Icons.info),
                title: Text('多版本下载网址,点击复制，密码是4huv'),
                subtitle:
                    Text('https://wwai.lanzouy.com/b02pwpe5e?password=4huv'),
                onTap: () {
                  //http://course.musecloud.tech/
                  Clipboard.setData(ClipboardData(
                      text:
                          'https://wwai.lanzouy.com/b02pwpe5e?password=4huv'));
                  AchievementView(context,
                      title: "复制成功",
                      subTitle: '可以去浏览器粘贴网址了',
                      //onTab: _onTabAchievement,
                      icon: Icon(
                        Icons.insert_emoticon,
                        color: Colors.white,
                      ),
                      color: Colors.green,
                      duration: Duration(seconds: 3),
                      isCircle: true, listener: (status) {
                    print(status);
                  })
                    ..show();
                },
              ),
              //请开发者喝杯咖啡
              ListTile(
                leading: Icon(Icons.coffee),
                title: Text('请开发者喝杯咖啡'),
                subtitle: Text('如果你觉得这个软件还不错，可以请开发者喝杯咖啡。'),
                onTap: () {
                  if (Platform.isAndroid)
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('请开发者喝杯咖啡'),
                            content: Text('如果你觉得这个软件还不错，可以请开发者喝杯咖啡。'),
                            actions: [
                              //判断是否ios设备

                              //展示图片
                              Image.asset('assets/pay/weixin.png'),
                            ],
                          );
                        });
                  else
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('苹果就不喝咖啡了'),
                            content: Text('自己用喝个屁'),
                            actions: [],
                          );
                        });
                },
              ),
              ListTile(
                  //你的推送id是
                  leading: Icon(Icons.info),
                  title: Text('你的推送id是(点击复制)'),
                  subtitle: Text(jpushs.rid),
                  onTap: () {
                    //复制到剪切板
                    Clipboard.setData(ClipboardData(text: jpushs.rid));
                  }),
              //彩蛋
              ListTile(
                leading: Icon(Icons.info),
                title: Text('彩蛋'),
                subtitle: Text(''),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        //两个彩蛋可以选择
                        return AlertDialog(
                          title: Text('彩蛋'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //跳转到彩蛋页面
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WelcomeScreen()));
                                  },
                                  child: Text('井字棋')),
                              //跳转到彩蛋页面
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GameScreen()));
                                  },
                                  child: Text('国际象棋')),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BlackJackScreen()));
                                  },
                                  child: Text('黑杰克')),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => wuziqi()));
                                  },
                                  child: Text('五子棋')),
                            ],
                          ),
                          actions: [],
                        );
                      });
                },
              ),
              //修改学号密码
              ListTile(
                leading: Icon(Icons.info),
                title: Text('修改学号密码'),
                subtitle: Text(''),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('修改学号密码'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                    labelText: "学号",
                                    hintText: "请输入学号",
                                    prefixIcon: Icon(Icons.person)),
                              ),
                              TextField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    labelText: "密码",
                                    hintText: "请输入密码",
                                    prefixIcon: Icon(Icons.lock)),
                              ),
                            ],
                          ),
                          actions: [
                            //跳转到彩蛋页面
                            ElevatedButton(
                                onPressed: () {
                                  //修改学号密码
                                  Global.jwc_xuehao = _usernameController.text;
                                  Global.jwc_password =
                                      _passwordController.text;
                                  Global().storelogininfo(
                                      _usernameController.text,
                                      _passwordController.text);
                                  //保存到本地
                                  Navigator.pop(context);
                                },
                                child: Text('修改'))
                          ],
                        );
                      });
                },
              ),
              //
              ListTile(
                leading: Icon(Icons.info),
                title: Text('ios也想用课程推送，点我复制网址'),
                subtitle: Text(''),
                onTap: () {
                  //http://course.musecloud.tech/
                  Clipboard.setData(
                      ClipboardData(text: 'http://course.musecloud.tech/'));
                  AchievementView(context,
                      title: "复制成功",
                      subTitle: '可以给你ios设备的朋友了',
                      //onTab: _onTabAchievement,
                      icon: Icon(
                        Icons.insert_emoticon,
                        color: Colors.white,
                      ),
                      color: Colors.green,
                      duration: Duration(seconds: 3),
                      isCircle: true, listener: (status) {
                    print(status);
                  })
                    ..show();
                },
              ),

              ListTile(
                  leading: Icon(Icons.image),
                  title: Text('选取主页logo图片'),
                  subtitle: Text(''),
                  onTap: () async {
                    //使用image_picker插件获取相册图片
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    //获取得到的图片
                    if (image != null) {
                      Directory directory =
                          await getApplicationDocumentsDirectory();
                      String path = directory.path + '/logo.png';
                      //将图片复制到应用程序的文档目录
                      File file = File(image.path);
                      file.copy(path);
                      AchievementView(context,
                          title: "图片替换成功",
                          subTitle: '可以去主页查看你的logo了',
                          //onTab: _onTabAchievement,
                          icon: Icon(
                            Icons.insert_emoticon,
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
              ListTile(
                  leading: Icon(Icons.image),
                  title: Text('选取日历背景图片'),
                  subtitle: Text(''),
                  onTap: () async {
                    //使用image_picker插件获取相册图片
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    //获取得到的图片
                    if (image != null) {
                      Directory directory =
                          await getApplicationDocumentsDirectory();
                      String path = directory.path + '/calendar.png';
                      //将图片复制到应用程序的文档目录
                      File file = File(image.path);
                      file.copy(path);
                      AchievementView(context,
                          title: "图片替换成功",
                          subTitle: '可以去主页右上角点击查看你的日历背景图了',
                          //onTab: _onTabAchievement,
                          icon: Icon(
                            Icons.insert_emoticon,
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
              ListTile(
                  leading: Icon(Icons.image),
                  title: Text('选取成绩卡片图片'),
                  subtitle: Text(''),
                  onTap: () async {
                    //使用image_picker插件获取相册图片
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    //获取得到的图片
                    if (image != null) {
                      Directory directory =
                          await getApplicationDocumentsDirectory();
                      String path = directory.path + '/card.png';
                      //将图片复制到应用程序的文档目录
                      File file = File(image.path);
                      file.copy(path);
                      AchievementView(context,
                          title: "图片替换成功",
                          subTitle: '可以去成绩详情页面查看你的卡片图了',
                          //onTab: _onTabAchievement,
                          icon: Icon(
                            Icons.insert_emoticon,
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
              ListTile(
                  leading: Icon(Icons.image),
                  title: Text('选取成绩头像图片'),
                  subtitle: Text(''),
                  onTap: () async {
                    //使用image_picker插件获取相册图片
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    //获取得到的图片
                    if (image != null) {
                      Directory directory =
                          await getApplicationDocumentsDirectory();
                      String path = directory.path + '/avater.png';
                      //将图片复制到应用程序的文档目录
                      File file = File(image.path);
                      file.copy(path);
                      AchievementView(context,
                          title: "图片替换成功",
                          subTitle: '可以去成绩详情页面查看你的头像了',
                          //onTab: _onTabAchievement,
                          icon: Icon(
                            Icons.insert_emoticon,
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
              ListTile(
                  leading: Icon(Icons.update),
                  title: Text('检测更新'),
                  subtitle: Text(''),
                  onTap: () {
                    getApplicationDocumentsDirectory().then((value) {
                      File file = new File(value.path + '/version.txt');
                      var dio = Dio();
                      dio
                          .get(
                              'https://update-nepucouseupdate-bmgwsddxxl.cn-hongkong.fcapp.run/update')
                          .then((value) {
                        //截取json中的version
                        String version = value.data[0]['version'];
                        Dialogs.materialDialog(
                          color: Colors.white,
                          msg: '要下载吗?',
                          title: '有新版本啦,版本号是' +
                              version.toString() +
                              "\n" +
                              value.data[0]['descrption'],
                          lottieBuilder: Lottie.asset(
                            'assets/rockert-new.json',
                            fit: BoxFit.contain,
                          ),
                          context: context,
                          actions: [
                            IconButton(
                              onPressed: () {
                                //将版本号写入
                                file.writeAsString(version.toString());
                                //关闭
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.cancel_outlined),
                            ),
                            IconButton(
                              onPressed: () async {
                                //将版本号写入
                                file.writeAsString(version.toString());
                                Navigator.pop(context);

                                //下载
                                ProgressDialog pd =
                                    ProgressDialog(context: context);
                                pd.show(
                                    max: 100,
                                    msg: '准备下载更新...',
                                    msgMaxLines: 5,
                                    completed: Completed(
                                      completedMsg: "下载完成!",
                                      completedImage: AssetImage
                                          //加载gif
                                          ("assets/completed.gif"),
                                      completionDelay: 2500,
                                    ));
                                await EasyAppInstaller.instance
                                    .downloadAndInstallApk(
                                  fileUrl: value.data[0]['link'],
                                  fileDirectory: "updateApk",
                                  fileName: "newApk.apk",
                                  explainContent: "快去开启权限！！！",
                                  onDownloadingListener: (progress) {
                                    if (progress < 100) {
                                      pd.update(
                                          value: progress.toInt(),
                                          msg: '安装包正在下载...');
                                    } else {
                                      pd.update(
                                          value: progress.toInt(),
                                          msg: '安装包下载完成...');
                                    }
                                  },
                                  onCancelTagListener: (cancelTag) {},
                                );
                              },
                              icon: Icon(Icons.check),
                            ),
                          ],
                        );
                      });
                    });

                    // MyDialog.snack('替换成功');
                  }),
              //捐赠人员
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text('捐赠人员'),
                subtitle: Text(''),
              ),
              //显示头像
              ListTile(
                leading: CircleAvatar(
                  //网络图片
                  backgroundImage: NetworkImage(
                    'https://q1.qlogo.cn/g?b=qq&nk=1617352787&s=100',
                  ),
                ),
                title: Text('k'),
                subtitle: Text('捐赠5元'),
              ),
              //项目离不开以下人员的支持
              ListTile(
                leading: Icon(Icons.groups),
                title: Text('项目离不开以下人员的支持(排名不分先后)'),
                subtitle: Text(''),
              ),
              //显示头像
              ListTile(
                leading: CircleAvatar(
                  //网络图片
                  backgroundImage: NetworkImage(
                    'https://q1.qlogo.cn/g?b=qq&nk=1051456414&s=100',
                  ),
                ),
                title: Text('种太阳'),
                subtitle: Text('Tester'),
              ),
              ListTile(
                leading: CircleAvatar(
                  //网络图片
                  backgroundImage: NetworkImage(
                    'https://q1.qlogo.cn/g?b=qq&nk=2190588538&s=100',
                  ),
                ),
                title: Text(' 生'),
                subtitle: Text('Tester'),
              ),
              ListTile(
                leading: CircleAvatar(
                  //网络图片
                  backgroundImage: NetworkImage(
                    'https://q1.qlogo.cn/g?b=qq&nk=2846111055&s=100',
                  ),
                ),
                title: Text('猜猜我是谁'),
                subtitle: Text('Tester'),
              ),
              ListTile(
                leading: CircleAvatar(
                  //网络图片
                  backgroundImage: NetworkImage(
                    'https://q1.qlogo.cn/g?b=qq&nk=3167491753&s=100',
                  ),
                ),
                title: Text('24号'),
                subtitle: Text('Tester'),
              ),
              ListTile(
                leading: CircleAvatar(
                  //网络图片
                  backgroundImage: NetworkImage(
                    'https://q1.qlogo.cn/g?b=qq&nk=1617352787&s=100',
                  ),
                ),
                title: Text('k'),
                subtitle: Text('Tester'),
              ),
              ListTile(
                leading: CircleAvatar(
                  //网络图片
                  backgroundImage: NetworkImage(
                    'https://q1.qlogo.cn/g?b=qq&nk=1601071777&s=100',
                  ),
                ),
                title: Text('冰美式不加糖'),
                subtitle: Text('Developer'),
              ),
              ListTile(
                leading: Icon(Icons.mail),
                title: Text('开发者邮箱,有好的建议?发送到下面的邮箱哦'),
                subtitle: Text('dunkysu@gmail.com'),
              ),
              //开源地址
              ListTile(
                leading: Icon(Icons.bug_report),
                title: Text('开源地址,想提issue?来下面哦'),
                subtitle: Text('https://github.com/Dough-su/nepu_course'),
              ),
              //项目离不开以下开源项目
              ListTile(
                leading: Icon(Icons.beenhere),
                title: Text('本项目离不开以下开源项目的支持'),
                subtitle: Text(''),
              ), //https://github.com/vpalcar/calendar_appbar
              ListTile(
                leading: Icon(Icons.beenhere),
                title: Text('calendar_agenda'),
                subtitle: Text('https://github.com/sud0su/calendar_agenda'),
              ), //https://github.com/abdulmanafpfassal/mtoast
              ListTile(
                leading: Icon(Icons.beenhere),
                title: Text('mtoast'),
                subtitle: Text('https://github.com/abdulmanafpfassal/mtoast'),
              ), //https://pub.dev/packages/dynamic_timeline
              ListTile(
                leading: Icon(Icons.beenhere),
                title: Text('flutter_slidable'),
                subtitle: Text('https://github.com/letsar/flutter_slidable'),
              ), //https://github.com/NearHuscarl/flutter_login
              ListTile(
                leading: Icon(Icons.beenhere),
                title: Text('flutter_login'),
                subtitle: Text('https://github.com/NearHuscarl/flutter_login'),
              ), //https://github.com/flutterchina/dio
              ListTile(
                leading: Icon(Icons.beenhere),
                title: Text('dio'),
                subtitle: Text('https://github.com/flutterchina/dio'),
              ), //https://github.com/flutter/plugins/tree/main/packages/shared_preferences/shared_preferences
              ListTile(
                leading: Icon(Icons.beenhere),
                title: Text('shared_preferences'),
                subtitle: Text(
                    'https://github.com/flutter/plugins/tree/main/packages/shared_preferences/shared_preferences'),
              ), //
              ListTile(
                leading: Icon(Icons.beenhere),
                title: Text('image_picker'),
                subtitle: Text(
                    'https://github.com/flutter/plugins/tree/main/packages/image_picker/image_picker'),
              ), //
              ListTile(
                leading: Icon(Icons.beenhere),
                title: Text('card_flip'),
                subtitle: Text('https://github.com/ZuYun/card_flip'),
              ), //
              //https://github.com/gfslx999/easy_app_installer
              ListTile(
                leading: Icon(Icons.beenhere),
                title: Text('easy_app_installer'),
                subtitle:
                    Text('https://github.com/gfslx999/easy_app_installer'),
              ),
              //https://github.com/raj457036/shrink_sidemenu_flutter
              ListTile(
                  leading: Icon(Icons.beenhere),
                  title: Text('shrink_sidemenu'),
                  subtitle: Text(
                      'https://github.com/raj457036/shrink_sidemenu_flutter')),
              //https://github.com/iamSahdeep/liquid_swipe_flutter
              ListTile(
                  leading: Icon(Icons.beenhere),
                  title: Text('liquid_swipe'),
                  subtitle: Text(
                      'https://github.com/iamSahdeep/liquid_swipe_flutter')),

              ListTile(
                  leading: Icon(Icons.beenhere),
                  title: Text('timlines'),
                  subtitle: Text('https://github.com/chulwoo-park/timelines')),
              ListTile(
                  leading: Icon(Icons.beenhere),
                  title: Text('rameez_animated_login_screen'),
                  subtitle: Text(
                      'https://pub.dev/packages/rameez_animated_login_screen')),
              ListTile(
                  leading: Icon(Icons.beenhere),
                  title: Text('tutorial_coach_mark'),
                  subtitle: Text(
                      'https://github.com/RafaelBarbosatec/tutorial_coach_mark')),
              ListTile(
                  leading: Icon(Icons.beenhere),
                  title: Text('lottie'),
                  subtitle: Text('https://github.com/xvrh/lottie-flutter')),
              ListTile(
                  leading: Icon(Icons.beenhere),
                  title: Text('Flutter-Progress-Dialog'),
                  subtitle: Text(
                      'https://github.com/emreesen27/Flutter-Progress-Dialog')),
              ListTile(
                  leading: Icon(Icons.beenhere),
                  title: Text('material_dialogs'),
                  subtitle:
                      Text('https://github.com/Ezaldeen99/material_dialogs')),
            ],
          ),
        ),
      ),
    );
  }
}

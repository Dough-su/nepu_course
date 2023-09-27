import 'dart:io';

import 'package:achievement_view/achievement_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muse_nepu_course/service/api_service.dart';
import 'package:muse_nepu_course/util/global.dart';
import 'package:muse_nepu_course/util/jpushs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Global.home_currentcolor,
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
            title: Text('内部版本号'),
            subtitle: Text(Global.version),
          ),
          ListTile(
              leading: Icon(Icons.info),
              title: Text('开源软件声明'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AboutDialog(
                      applicationName: '东油课表',
                      children: [
                        Text('下方查看开源声明'),
                      ],
                    );
                  },
                );
              }),
          //切换课程自动更新开关
          ListTile(
            leading: Icon(Icons.info),
            title: Text('课程自动更新'),
            subtitle: Text('开启后，每次打开软件都会自动更新课程表。'),
            trailing: Switch(
              activeColor: Global.home_currentcolor,
              onChanged: (value) {
                setState(() {
                  Global.auto_update_course = value;
                  Global.saveauto_update_course();
                });
              },
              value: Global.auto_update_course,
            ),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('展示有课的日期'),
            subtitle: Text('开启后，请重新打开课表，请注意，开启此项会导致课表性能下降'),
            trailing: Switch(
                activeColor: Global.home_currentcolor,
                onChanged: (value) {
                  setState(() {
                    Global.show_course_day = value;
                    Global.save_show_course_day();
                  });
                },
                value: Global.show_course_day),
          ),
          //多版本下载网址，可以复制到剪切板
          ListTile(
            leading: Icon(Icons.info),
            title: Text('多版本下载网址,点击复制'),
            subtitle: Text(
                'https://www.musec.tech/%E4%B8%9C%E6%B2%B9%E8%AF%BE%E8%A1%A8'),
            onTap: () {
              Global().GlaunchUrl(
                  'https://www.musec.tech/%E4%B8%9C%E6%B2%B9%E8%AF%BE%E8%A1%A8');
              //http://course.musecloud.tech/
              Clipboard.setData(ClipboardData(
                  text:
                      'https://www.musec.tech/%E4%B8%9C%E6%B2%B9%E8%AF%BE%E8%A1%A8'));
              AchievementView(
                  title: "复制成功",
                  subTitle: '可以去浏览器粘贴网址了',
                  //onTab: _onTabAchievement,
                  icon: Icon(
                    Icons.insert_emoticon,
                    color: Colors.white,
                  ),
                  color: Colors.green,
                  duration: Duration(seconds: 3),
                  isCircle: true,
                  listener: (status) {
                    print(status);
                  })
                ..show(context);
            },
          ),
          //开启桌面悬浮窗
          if (Platform.isWindows)
            ListTile(
              leading: Icon(Icons.info),
              title: Text('开启桌面悬浮窗'),
              subtitle: Text('开启后，可以在桌面看到课程表'),
              trailing: Switch(
                activeColor: Global.home_currentcolor,
                onChanged: (value) {
                  setState(() {
                    Global.desktop_float = value;
                    Global.savedesktop_float();
                  });
                },
                value: Global.desktop_float,
              ),
            ),
          //请开发者喝杯咖啡
          ListTile(
            leading: Icon(Icons.coffee),
            title: Text('请开发者喝杯咖啡'),
            subtitle: Text('如果你觉得这个软件还不错，可以请开发者喝杯咖啡。'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('请开发者喝杯咖啡'),
                      content: Text('如果你觉得这个软件还不错，可以请开发者喝杯咖啡。'),
                      actions: [
                        //展示图片
                        Image.asset('assets/pay/weixin.png'),
                      ],
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
                        ElevatedButton(
                            onPressed: () {
                              //修改学号密码
                              Global.jwc_xuehao = _usernameController.text;
                              Global.jwc_password = _passwordController.text;
                              Global().storelogininfo(_usernameController.text,
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
                  AchievementView(
                      title: "图片替换成功",
                      subTitle: '可以去主页查看你的logo了',
                      //onTab: _onTabAchievement,
                      icon: Icon(
                        Icons.insert_emoticon,
                        color: Colors.white,
                      ),
                      color: Colors.green,
                      duration: Duration(seconds: 3),
                      isCircle: true,
                      listener: (status) {
                        print(status);
                      })
                    ..show(context);
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
                  AchievementView(
                      title: "图片替换成功",
                      subTitle: '可以去主页右上角点击查看你的日历背景图了',
                      //onTab: _onTabAchievement,
                      icon: Icon(
                        Icons.insert_emoticon,
                        color: Colors.white,
                      ),
                      color: Colors.green,
                      duration: Duration(seconds: 3),
                      isCircle: true,
                      listener: (status) {
                        print(status);
                      })
                    ..show(context);
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
                  AchievementView(
                      title: "图片替换成功",
                      subTitle: '可以去成绩详情页面查看你的卡片图了',
                      //onTab: _onTabAchievement,
                      icon: Icon(
                        Icons.insert_emoticon,
                        color: Colors.white,
                      ),
                      color: Colors.green,
                      duration: Duration(seconds: 3),
                      isCircle: true,
                      listener: (status) {
                        print(status);
                      })
                    ..show(context);
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
                  AchievementView(
                      title: "图片替换成功",
                      subTitle: '可以去成绩详情页面查看你的头像了',
                      //onTab: _onTabAchievement,
                      icon: Icon(
                        Icons.insert_emoticon,
                        color: Colors.white,
                      ),
                      color: Colors.green,
                      duration: Duration(seconds: 3),
                      isCircle: true,
                      listener: (status) {
                        print(status);
                      })
                    ..show(context);
                }
              }),
          ListTile(
              leading: Icon(Icons.update),
              title: Text('检测更新'),
              subtitle: Text(''),
              onTap: () {
                ApiService().updateappx(context, "");
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

          ListTile(
            leading: CircleAvatar(
              //网络图片
              backgroundImage: NetworkImage(
                'https://q1.qlogo.cn/g?b=qq&nk=2190588538&s=100',
              ),
            ),
            title: Text('生'),
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
            title: Text('果然多cc果卷'),
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
            onTap: () {
              Global().GlaunchUrl(
                  'https://github.com/Dough-su/nepu_course'
              );
            }
          ),
        ],
      )),
    );
  }
}

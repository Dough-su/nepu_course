import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:shirne_dialog/shirne_dialog.dart';

class about extends StatefulWidget {
  @override
  _aboutState createState() => _aboutState();
}

var logourl = '';

class _aboutState extends State<about> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            //项目离不开以下人员的支持
            ListTile(
              leading: Icon(Icons.groups),
              title: Text('项目离不开以下人员的支持(以下排名不分先后)'),
              subtitle: Text(''),
            ),
            //选取图片

            ListTile(
                leading: Icon(Icons.image),
                title: Text('输入logo图片链接'),
                subtitle: Text(''),
                onTap: () {
                  //弹出输入框
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('输入logo图片地址(不支持本地选取，请自行上传到图床)'),
                          content: Text(''),
                          actions: [
                            //弹出输入框
                            TextField(
                              controller: TextEditingController(),
                              //保存输入的内容
                              onChanged: (value) {
                                //保存输入的内容
                                logourl = value;
                              },
                              decoration: InputDecoration(
                                hintText: '请输入图片地址',
                              ),
                            ),
                            //确认按钮
                            TextButton(
                              child: Text('确认'),
                              onPressed: () async {
                                print('url是' + logourl);
                                //关闭弹出框
                                Navigator.of(context).pop();
                                //使用dio下载图片到应用目录
                                Directory directory =
                                    await getApplicationDocumentsDirectory();
                                String path = directory.path + '/logo.png';
                                Dio dio = new Dio();
                                MyDialog.navigatorKey;

                                //获取输入框的地址
                                final controller = MyDialog.loading(
                                  '下载中',
                                  showProgress: true,
                                  duration: Duration.zero,
                                );
                                //下载图片后提示用户
                                await dio.download(logourl, path,
                                    onReceiveProgress: (int count, int total) {
                                  controller.value = count / total;
                                });
                              },
                            ),
                          ],
                        );
                      });
                }),
            ListTile(
                leading: Icon(Icons.image),
                title: Text('输入日历背景图片链接'),
                subtitle: Text(''),
                onTap: () {
                  //弹出输入框
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('输入日历背景图片地址(不支持本地选取，请自行上传到图床)'),
                          content: Text(''),
                          actions: [
                            //弹出输入框
                            TextField(
                              controller: TextEditingController(),
                              //保存输入的内容
                              onChanged: (value) {
                                //保存输入的内容
                                logourl = value;
                              },
                              decoration: InputDecoration(
                                hintText: '请输入图片地址',
                              ),
                            ),
                            //确认按钮
                            TextButton(
                              child: Text('确认'),
                              onPressed: () async {
                                print('url是' + logourl);
                                //关闭弹出框
                                Navigator.of(context).pop();
                                //使用dio下载图片到应用目录
                                Directory directory =
                                    await getApplicationDocumentsDirectory();
                                String path = directory.path + '/calendar.png';
                                Dio dio = new Dio();
                                MyDialog.navigatorKey;

                                //获取输入框的地址
                                final controller = MyDialog.loading(
                                  '下载中',
                                  showProgress: true,
                                  duration: Duration.zero,
                                );
                                //下载图片后提示用户
                                await dio.download(logourl, path,
                                    onReceiveProgress: (int count, int total) {
                                  controller.value = count / total;
                                });
                              },
                            ),
                          ],
                        );
                      });
                }),
            ListTile(
                leading: Icon(Icons.image),
                title: Text('输入成绩卡片图片链接'),
                subtitle: Text(''),
                onTap: () {
                  //弹出输入框
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('输入成绩卡片图片地址(不支持本地选取，请自行上传到图床)'),
                          content: Text(''),
                          actions: [
                            //弹出输入框
                            TextField(
                              controller: TextEditingController(),
                              //保存输入的内容
                              onChanged: (value) {
                                //保存输入的内容
                                logourl = value;
                              },
                              decoration: InputDecoration(
                                hintText: '请输入图片地址',
                              ),
                            ),
                            //确认按钮
                            TextButton(
                              child: Text('确认'),
                              onPressed: () async {
                                print('url是' + logourl);
                                //关闭弹出框
                                Navigator.of(context).pop();
                                //使用dio下载图片到应用目录
                                Directory directory =
                                    await getApplicationDocumentsDirectory();
                                String path = directory.path + '/card.png';
                                Dio dio = new Dio();
                                MyDialog.navigatorKey;

                                //获取输入框的地址
                                final controller = MyDialog.loading(
                                  '下载中',
                                  showProgress: true,
                                  duration: Duration.zero,
                                );
                                //下载图片后提示用户
                                await dio.download(logourl, path,
                                    onReceiveProgress: (int count, int total) {
                                  controller.value = count / total;
                                });
                              },
                            ),
                          ],
                        );
                      });
                }),
            ListTile(
                leading: Icon(Icons.image),
                title: Text('输入成绩头像图片链接'),
                subtitle: Text(''),
                onTap: () {
                  //弹出输入框
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('输入成绩头像图片地址(不支持本地选取，请自行上传到图床)'),
                          content: Text(''),
                          actions: [
                            //弹出输入框
                            TextField(
                              controller: TextEditingController(),
                              //保存输入的内容
                              onChanged: (value) {
                                //保存输入的内容
                                logourl = value;
                              },
                              decoration: InputDecoration(
                                hintText: '请输入图片地址',
                              ),
                            ),
                            //确认按钮
                            TextButton(
                              child: Text('确认'),
                              onPressed: () async {
                                print('url是' + logourl);
                                //关闭弹出框
                                Navigator.of(context).pop();
                                //使用dio下载图片到应用目录
                                Directory directory =
                                    await getApplicationDocumentsDirectory();
                                String path = directory.path + '/avater.png';
                                Dio dio = new Dio();
                                MyDialog.navigatorKey;

                                //获取输入框的地址
                                final controller = MyDialog.loading(
                                  '下载中',
                                  showProgress: true,
                                  duration: Duration.zero,
                                );
                                //下载图片后提示用户
                                await dio.download(logourl, path,
                                    onReceiveProgress: (int count, int total) {
                                  controller.value = count / total;
                                });
                              },
                            ),
                          ],
                        );
                      });
                }),
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
              title: Text('calendar_appbar'),
              subtitle: Text('https://github.com/vpalcar/calendar_appbar'),
            ), //https://github.com/abdulmanafpfassal/mtoast
            ListTile(
              leading: Icon(Icons.beenhere),
              title: Text('mtoast'),
              subtitle: Text('https://github.com/abdulmanafpfassal/mtoast'),
            ), //https://pub.dev/packages/dynamic_timeline
            ListTile(
              leading: Icon(Icons.beenhere),
              title: Text('dynamic_timeline'),
              subtitle: Text('https://pub.dev/packages/dynamic_timeline'),
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
          ],
        ),
      ),
    );
  }
}

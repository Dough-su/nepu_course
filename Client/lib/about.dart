import 'package:flutter/material.dart';

class about extends StatefulWidget {
  @override
  _aboutState createState() => _aboutState();
}

class _aboutState extends State<about> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关于'),
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

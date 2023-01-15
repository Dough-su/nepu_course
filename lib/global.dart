import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:muse_nepu_course/home.dart';
import 'package:muse_nepu_course/login/login.dart';
import 'package:path_provider/path_provider.dart';
import 'package:muse_nepu_course/coursemenu/pingjiao.dart';
import 'package:muse_nepu_course/coursemenu/scoredetail.dart';

class Global {
  //版本号(每次正式发布都要改，改成和数据库一样)
  static String version = "106";
  //教务处学号
  static String jwc_xuehao = '';
  //教务处密码
  static String jwc_password = '';
  //教务处JSESSIONID
  static String jwc_jsessionid = '';
  //教务处验证码
  static String jwc_verifycode = '';
  //教务处webvpn_key
  static String jwc_webvpn_key = '';
  //教务处webvpn_username
  static String jwc_webvpn_username = '';
  //课表日历第一天
  static DateTime calendar_first_day =
      DateTime.now().subtract(Duration(days: 1400));
  //判断是否已经从本地读取json
  bool isfirstread = true;
  //课表日历最后一天
  static DateTime calendar_last_day = DateTime.now().add(Duration(days: 180));
  //在内存中的courseinfo
  static var courseInfox;
  //教务处学号setter
  jwc_xuehaosetter(jwc_xuehao) {
    Global.jwc_xuehao = jwc_xuehao;
  }

  //教务处密码setter
  jwc_passwordsetter(jwc_password) {
    Global.jwc_password = jwc_password;
  }

  //将用户名和密码导入到global.dart中
  void getusername() async {
    await getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/logininfo.txt');
      if (file.existsSync()) {
        //根据,分割
        List<String> list = file.readAsStringSync().split(',');
        Global().jwc_xuehaosetter(list[0]);
        Global().jwc_passwordsetter(list[1]);
      }
    });
  }

  void storelogininfo(username, password) {
    Global.jwc_xuehao = username;
    Global.jwc_password = password;
    getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/logininfo.txt');
      //判断是否存在file
      file.exists().then((value) {
        if (value) {
          //如果存在则删除
          file.delete();
        }
        //创建file
        file.create();
        //写入username和password分别占一行
        file.writeAsString('$username,$password');
      });
    });
  }

  //使用Dio插件获取验证码图片并返回图片
  static Future<Widget> getVerifyCode(_pureyzm) async {
    if (!_pureyzm) {
      Dio dio = Dio();
      Response response = await dio.get(
          "https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/jwc_login",
          options: Options(responseType: ResponseType.bytes));
      print(response.headers.value('Set-Cookie').toString());
      //如果分割后的字符串长度为32则为jessonid
      for (var item in response.headers
          .value('Set-Cookie')
          .toString()
          .replaceAll('{', '')
          .replaceAll('}', '')
          .replaceAll("'", '')
          .replaceAll(' ', '')
          .split(',')) {
        if (item.length < 50) {
          jwc_jsessionid = item;
        }
        if (item.length > 100) {
          jwc_webvpn_key = item;
        }
        if (item.length > 50 && item.length < 100) {
          jwc_webvpn_username = item;
        }
      }
      return Image.memory(response.data);
    } else {
      return Image.asset('assets/jwc_login.jpg');
    }
  }

  //读取登录信息
  Future<String> getLoginInfo() async {
    return '?JSESSIONID=' +
        jwc_jsessionid +
        '&_webvpn_key=' +
        jwc_webvpn_key +
        '&webvpn_username=' +
        jwc_webvpn_username;
  }

  //加载需要绘制的日期范围
  Future<bool> loaddate() async {
    //getApplicationDocumentsDirectory()方法获取应用程序的文档目录
    await getApplicationDocumentsDirectory().then((value) {
      File file = new File(value.path + '/calanderagenda.txt');
      file.exists().then((value) {
        if (value) {
          print('读取到文件了');
          //读取数据
          file.readAsString().then((value) {
            //读取数据第一行
            List<String> list = value.split('\n');
            Global.calendar_first_day = DateTime(
                int.parse(list[1].toString().split('-')[0]),
                int.parse(list[1].toString().split('-')[1]),
                int.parse(list[1].toString().split('-')[2]));
          });
          print('读完了');
          return false;
        } else {
          print('没有读取到文件');
          return true;
        }
      });
    });
    return true;
  }

  //判断是不是首次登录
  void isFirst(context) {
    //getApplicationDocumentsDirectory()方法获取应用程序的文档目录
    getApplicationDocumentsDirectory().then((value) {
      File file = new File(value.path + '/course.json');
      file.exists().then((value) {
        if (value) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
      });
    });
  }

  //登录页面
  Widget loginreq(String login_title, _authUser, context, bool _pureyzm,
      setState, contextbuilder) {
    return FlutterLogin(
      title: login_title,
      onLogin: (loginData) {
        return _authUser(loginData);
      },
      hideForgotPasswordButton: true,
      userType: LoginUserType.name,
      savedEmail: Global.jwc_xuehao,
      savedPassword: Global.jwc_password,
      onSubmitAnimationCompleted: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => contextbuilder));
      },
      onRecoverPassword: (name) {
        return null;
      },
      children: [
        //添加验证码图片
        //修改验证码图片大小
        Container(
          //点击刷新
          child: GestureDetector(
            onTap: () {
              setState(() {
                Global.getVerifyCode(_pureyzm);
              });
            },
            child: Container(
              child: FutureBuilder(
                future: Global.getVerifyCode(_pureyzm),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data as Widget;
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ),
          width: 100,
          height: 30,
          margin: EdgeInsets.only(top: 220),
        ),
      ],
    );
  }

  //读取下载的json
  Future<String> getCourseInfo() async {
    //获取路径
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/course.json';
    //读取文件
    File file = new File(path);
    String courseInfo = await file.readAsString();
    return courseInfo;
  }

  //加载课程到内存
  loadItems(DateTime date) async {
    if (isfirstread)
      getCourseInfo().then((value) async {
        courseInfox = json.decode(value);
        isfirstread = false;
      }).then((value) {
        try {
          courseInfox[0]['jsrq'];
          //写入jsrq到文件
          getApplicationDocumentsDirectory().then((value) {
            File file = File(value.path + '/calanderagenda.txt');
            //判断文件是否存在
            if (file.existsSync()) {
              //存在则写入第一条数据和最后一条数据，并换行
              file.writeAsStringSync(courseInfox[0]['jsrq'] +
                  '\n' +
                  courseInfox[courseInfox.length - 1]['jsrq']);
            } else {
              //不存在则创建文件并写入
              file.createSync();
              file.writeAsStringSync(courseInfox[0]['jsrq'] +
                  '\n' +
                  courseInfox[courseInfox.length - 1]['jsrq']);
            }
          });
        } catch (e) {
          dailycourse = [
            Text(
              '当你看到这段话，证明出错了，当然可能服务器出错了(概率很小),出错在哪里了呢，可能在于学校，学校是不是现在正在有选课的问题，有这个问题的话，可能会导致超时，因为教务处压力太大，导致没办法加载，下次建议不要在抢课时登陆课表，现在你可以点开三个横那里，里面有个清除课程和成绩缓存，按下它，退出app，等到学校不在抢课时重新登陆吧，good luck',
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
              ),
            )
          ];

          return;
        }
      });
  }
}

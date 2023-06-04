import 'dart:convert';
import 'dart:io';
import 'package:achievement_view/achievement_view.dart';
import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:card_flip/card_flip.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:muse_nepu_course/coursemenu/scoredetail.dart';
import 'package:muse_nepu_course/flutterlogin/flutter_login.dart';
import 'package:muse_nepu_course/home.dart';
import 'package:muse_nepu_course/login/login.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'service/api_service.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flustars/flustars.dart';
import 'package:encrypt/encrypt.dart' as enc;

class LoginData {
  final String name;
  final String password;
  late String verifyCode;

  void verifycodeset(String verifyCode) {
    this.verifyCode = verifyCode;
  }

  LoginData(
      {required this.name, required this.password, required this.verifyCode});

  @override
  String toString() {
    return 'LoginData($name, $password, $verifyCode)';
  }

  @override
  bool operator ==(Object other) {
    if (other is LoginData) {
      return name == other.name &&
          password == other.password &&
          verifyCode == other.verifyCode;
    }
    return false;
  }

  @override
  int get hashCode => hash2(name, password);
}

///定义秘钥
var _KEY = "0123456789becoin";

///定义偏移量
var _IV = "0123456789becoin";

class Global {
  static TextEditingController jwc_verifycodeController =
      TextEditingController(text: '');
  //版本号(每次正式发布都要改，改成和数据库一样)
  static String version = "134";
  //教务处学号
  static String jwc_xuehao = '';
  //教务处密码
  static String jwc_password = '';
  //用户2教务处学号
  static String jwc_xuehao2 = '';
  //用户2教务处密码
  static String jwc_password2 = '';
  //教务处JSESSIONID
  static String jwc_jsessionid = '';
  //用户2教务处JSESSIONID
  static String jwc_jsessionid2 = '';
  //教务处验证码
  static String jwc_verifycode = '';
  //教务处webvpn_key
  static String jwc_webvpn_key = '';
  //教务处webvpn_username
  static String jwc_webvpn_username = '';
  //教务处2验证码
  static String jwc_verifycode2 = '';
  //教务处2webvpn_key
  static String jwc_webvpn_key2 = '';
  //教务处2webvpn_username
  static String jwc_webvpn_username2 = '';
  //主页的currentcolor
  static Color home_currentcolor = Colors.blue;
  //主页的pickcolor
  static Color home_pickcolor = Colors.blue;
  //成绩页面的currentcolor
  static Color score_currentcolor = Colors.blue;
  //成绩页面的pickcolor
  static Color score_pickcolor = Colors.blue;
  //课表日历第一天
  static DateTime calendar_first_day =
      DateTime.now().subtract(Duration(days: 1400));
  //用户2课表日历第一天
  static DateTime calendar_first_day2 =
      DateTime.now().subtract(Duration(days: 1400));
  //课表当前日期
  static DateTime calendar_current_day = DateTime.now();
  //用户2课表当前日期
  static DateTime calendar_current_day2 = DateTime.now();
  //透明验证码
  static bool _pureyzm = false;
  //评教进入模式是否为无感知登录(默认用无感知登录)
  static bool pingjiao_login_mode = true;
  //判断是否已经从本地读取json
  static bool isfirstread = true;
  //判断用户2是否已经从本地读取json
  static bool isfirstread2 = true;
  //课表日历最后一天
  static DateTime calendar_last_day = DateTime.now().add(Duration(days: 180));
  //用户2课表日历最后一天
  static DateTime calendar_last_day2 = DateTime.now().add(Duration(days: 180));
  //在内存中的courseinfo
  static var courseInfox;
  //用户2在内存中的courseinfo
  static var courseInfox2;
  //本次启动是否已经刷新课程
  static bool isrefreshcourse = false;
  //本次启动用户2是否已经刷新课程
  static bool isrefreshcourse2 = false;
  //自动更新课程
  static bool auto_update_course = true;
  //消息列表
  static List<types.Message> messages = [];
  //String类型的消息列表
  static String messages_pure = '';
  //注入消息
  static String pre_message = '';
  //账号
  static String account = '';
  //密码
  static String password = '';
  //qrocde
  static String qrcode = '';
  //有课的日期
  static List<DateTime> course_day = [];
  //用户2有课的日期
  static List<DateTime> course_day2 = [];
  //是否显示有课的日期
  static bool show_course_day = true;
  ApiService apiService = ApiService();
  //当前用户是否是第一个
  static bool isfirstuser = true;
  //用户2是否登陆过
  static bool islogin2 = false;
  //保存用户2是否登陆过到文件
  void saveislogin2() async {
    await getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/islogin2.txt');
      file.writeAsStringSync(islogin2.toString());
    });
  }

  //读取用户2是否登陆过到文件
  void readislogin2() async {
    await getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/islogin2.txt');
      if (file.existsSync()) {
        islogin2 = file.readAsStringSync() == 'true' ? true : false;
      }
    });
  }

  //文本控制器
  static TextEditingController textEditingController =
      TextEditingController(text: '');

  Encrypt(String username, String password) {
    try {
      final key = enc.Key.fromUtf8(_KEY);
      final iv = enc.IV.fromUtf8(_IV);
      final plainText = username +
          " " +
          password +
          " " +
          DateTime.now().millisecondsSinceEpoch.toString(); // 在明文中加入当前时间戳

      final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      return encrypted.base16;
    } catch (err) {
      print("aes encode error:$err");
    }
  }

  dynamic Decrypt(encrypted, BuildContext context) {
    try {
      final key = enc.Key.fromUtf8(_KEY);
      final iv = enc.IV.fromUtf8(_IV);
      final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
      final decrypted = encrypter.decrypt16(encrypted, iv: iv);

      final parts = decrypted.split(' ');
      final timestamp = int.tryParse(parts.last); // 解析时间戳
      if (timestamp == null ||
          DateTime.now().millisecondsSinceEpoch - timestamp > 5 * 60 * 1000) {
        AchievementView(context,
            title: "警告",
            subTitle: '密钥已超过时效',
            //onTab: _onTabAchievement,
            icon: Icon(
              Icons.insert_emoticon,
              color: Colors.white,
            ),
            color: Colors.red,
            duration: Duration(seconds: 3),
            isCircle: true, listener: (status) {
          print(status);
        })
          ..show();
        throw Exception("Decryption failed"); // 如果时间戳无效或超过5分钟，则解密失败
      }
      String plain =
          decrypted.substring(0, decrypted.length - parts.last.length - 1);
      jwc_xuehao2 = plain.split(' ')[0];
      jwc_password2 = plain.split(' ')[1];
      storelogininfo2(jwc_xuehao2, jwc_password2);
      print(jwc_xuehao2 + jwc_password2);

      islogin2 = true;
      return ('success'); // 返回去掉时间戳的明文部分
    } catch (err) {
      print("aes decode error:$err");
      AchievementView(context,
          title: "警告",
          subTitle: '你的密钥不对哦',
          //onTab: _onTabAchievement,
          icon: Icon(
            Icons.insert_emoticon,
            color: Colors.white,
          ),
          color: Colors.red,
          duration: Duration(seconds: 3),
          isCircle: true, listener: (status) {
        print(status);
      })
        ..show();
      return encrypted;
    }
  }

  //保存是否显示有课的日期到文件
  static void save_show_course_day() async {
    await getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/show_course_day.txt');
      file.writeAsStringSync(show_course_day.toString(), mode: FileMode.write);
    });
  }

  //读取是否显示有课的日期
  static Future<bool> get_show_course_day() async {
    await getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/show_course_day.txt');
      if (file.existsSync()) {
        show_course_day = file.readAsStringSync() == 'true' ? true : false;
        return show_course_day;
      }
    });
    return false;
  }

  //qrocdegetter
  static String qrcodegetter() {
    return qrcode;
  }

  //qrcode刷新时间
  static DateTime qrcode_time = DateTime.now();
  //保存账号密码到文件
  static void saveaccount() async {
    await getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/account.txt');
      file.writeAsStringSync(account + ' ' + password, mode: FileMode.write);
    });
  }

  //从文件读取最后一天和第一天
  static void getcalendar() async {
    await getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/calanderagenda.txt');
      if (file.existsSync()) {
        calendar_first_day =
            DateTime.parse(file.readAsStringSync().split('\n')[1]);
        calendar_last_day =
            DateTime.parse(file.readAsStringSync().split('\n')[0]);
      }
    });
  }

  //从文件读取用户2最后一天和第一天
  static void getcalendar2() async {
    await getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/calanderagenda1.txt');
      if (file.existsSync()) {
        calendar_first_day2 =
            DateTime.parse(file.readAsStringSync().split('\n')[1]);
        calendar_last_day2 =
            DateTime.parse(file.readAsStringSync().split('\n')[0]);
      }
    });
  }

  //从文件中读取账号密码
  void getaccount() async {
    await getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/account.txt');
      if (file.existsSync()) {
        account = file.readAsStringSync().split(' ')[0];
        password = file.readAsStringSync().split(' ')[1];
        print("账号密码" + account + password);
      }
      getaccno();
    });
  }

//保存
  //保存自动更新课程状态到文件
  static void saveauto_update_course() async {
    await getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/auto_update_course.txt');
      file.writeAsStringSync(auto_update_course.toString(),
          mode: FileMode.write);
    });
  }

  //从文件中读取自动更新课程状态
  static void getauto_update_course() async {
    await getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/auto_update_course.txt');
      if (file.existsSync()) {
        if (file.readAsStringSync() == 'true') {
          auto_update_course = true;
        } else {
          auto_update_course = false;
        }
      }
    });
  }

  //上滑锁定
  static bool locked = false;
  //一卡通余额
  static String yikatong_balance = '';
  //成绩组件列表
  static List<Widget> scorelist = [];
  //用户2成绩组件列表
  static List<Widget> scorelist2 = [];
  //成绩信息
  static var scoreinfos = [];
  //用户2成绩信息
  static var scoreinfos2 = [];
  //底栏高度
  static double bottombarheight = 60;
  //一卡通近期流水
  static List yikatong_recent = [];
  //桌面平台的高度
  static double desktopheight = 400;
  //桌面平台的宽度
  static double desktopwidth = 600;
  //桌面平台的x坐标
  static double desktopx = 0;
  //桌面平台的y坐标
  static double desktopy = 0;
  //无感登陆重试次数
  static int login_retry = 0;
  //成绩页面的图片
  ImageProvider cardpic = AssetImage('images/image.png');
  ImageProvider avaterpic = AssetImage('images/avatar.png');
  //主页logo图片
  ImageProvider calendarlogo = AssetImage('images/logo.png');
  ImageProvider logopic = AssetImage('images/logo.png');

  //保存桌面的高度，宽度，x坐标，y坐标到文件
  static void savedesktopinfo() async {
    await getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/desktopinfo.txt');
      file.writeAsStringSync(
          desktopheight.toString() +
              ',' +
              desktopwidth.toString() +
              ',' +
              desktopx.toString() +
              ',' +
              desktopy.toString(),
          mode: FileMode.write);
    });
  }

  //从文件中读取桌面的高度，宽度，x坐标，y坐标
  static void getdesktopinfo() async {
    await getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/desktopinfo.txt');
      if (file.existsSync()) {
        List<String> list = file.readAsStringSync().split(',');
        desktopheight = double.parse(list[0]);
        desktopwidth = double.parse(list[1]);
        desktopx = double.parse(list[2]);
        desktopy = double.parse(list[3]);
      }
    });
  }

  //透明验证码setter
  static void pureyzmset(bool pureyzm) {
    _pureyzm = pureyzm;
  }

  //透明验证码getter
  static bool pureyzmgetter() {
    return _pureyzm;
  }

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
        print('读取到的学号' + file.readAsStringSync().split(',')[0]);
        List<String> list = file.readAsStringSync().split(',');
        Global().jwc_xuehaosetter(list[0]);
        Global().jwc_passwordsetter(list[1]);
      }
    });
  }

  //将用户名和密码导入到global.dart中
  static getusername2() async {
    await getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/logininfo1.txt');
      if (file.existsSync()) {
        //根据,分割
        List<String> list = file.readAsStringSync().split(',');
        jwc_xuehao2 = list[0];
        jwc_password2 = list[1];
      }
    });
  }

  //存储用户名和密码
  void storelogininfo(username, password) {
    Global.jwc_xuehao = username;
    Global.jwc_password = password;
    getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/logininfo.txt');
      //创建file
      file.create();
      //判断是否存在file
      file.exists().then((value) {
        //写入username和password分别占一行
        file.writeAsString('$username,$password');
      });
    });
  }

  //存储用户2名和密码
  void storelogininfo2(username, password) {
    Global.jwc_xuehao2 = username;
    Global.jwc_password2 = password;
    getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/logininfo1.txt');
      //创建file
      file.create();
      //判断是否存在file
      file.exists().then((value) {
        //写入username和password分别占一行
        file.writeAsString('$username,$password');
      });
    });
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

  //读取用户2登录信息
  Future<String> getLoginInfo2() async {
    return '?JSESSIONID=' +
        jwc_jsessionid2 +
        '&_webvpn_key=' +
        jwc_webvpn_key +
        '&webvpn_username=' +
        jwc_webvpn_username;
  }

  //判断是不是首次登录
  void isFirst(context) {
    //getApplicationDocumentsDirectory()方法获取应用程序的文档目录
    getApplicationDocumentsDirectory().then((value) {
      File file = new File(value.path + '/course.json');
      file.exists().then((value) {
        if (value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
      });
    });
  }

  //登录页面
  Widget loginreq(
      String login_title, _authUser, context, setState, contextbuilder) {
    return Center(
        child: FlutterLogin(
      title: login_title,
      onLogin: (loginData) {
        return _authUser(loginData);
      },
      hideForgotPasswordButton: true,
      userType: LoginUserType.name,
      savedEmail: jwc_xuehao,
      savedPassword: jwc_password,
      yazhengma: Container(),
      verifyCode: '',
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
            child: Container(
              child: FutureBuilder(
                future: apiService.getVerifyCode(context, setState),
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
    ));
  }

  //加载课程到内存
  loadItems(DateTime date) async {
    if (isfirstread == true) {
      getCourseInfo().then((value) async {
        courseInfox = json.decode(value);
        isfirstread = false;
      }).then((value) {
        print('加载课程到内存');
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
            File file1 = File(value.path + '/hascourse.json');
            //判断文件是否存在
            if (file1.existsSync()) {
              //清空
              file1.writeAsStringSync('');
              //将所有课程的日期换行写入文件
              for (var item in courseInfox) {
                file1.writeAsStringSync(item['jsrq'] + '\n',
                    mode: FileMode.append);
              }
            } else {
              //不存在则创建文件并写入
              file1.createSync();
              for (var item in courseInfox) {
                file1.writeAsStringSync(item['jsrq'] + '\n',
                    mode: FileMode.append);
              }
            }
          });
        } catch (e) {
          dailycourse = [
            Text(
              '当你看到这段话，证明出错了，当然可能服务器出错了(概率很小),出错在哪里了呢，可能在于学校，学校是不是现在正在有选课的问题，有这个问题的话，可能会导致超时，因为教务处压力太大，导致没办法加载，下次建议不要在抢课时登陆课表，现在你可以点开三个横那里，里面有个重新登入，按下它，退出app，等到学校不在抢课时重新登陆吧，good luck',
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

  //加载用户2课程到内存
  loadItems2(DateTime date) async {
    if (isfirstread2 == true) {
      getCourseInfo2().then((value) async {
        courseInfox2 = json.decode(value);
        isfirstread2 = false;
      }).then((value) {
        print('加载课程到内存');
        try {
          courseInfox2[0]['jsrq'];
          //写入jsrq到文件
          getApplicationDocumentsDirectory().then((value) {
            File file = File(value.path + '/calanderagenda1.txt');
            //判断文件是否存在
            if (file.existsSync()) {
              //存在则写入第一条数据和最后一条数据，并换行
              file.writeAsStringSync(courseInfox2[0]['jsrq'] +
                  '\n' +
                  courseInfox2[courseInfox2.length - 1]['jsrq']);
            } else {
              //不存在则创建文件并写入
              file.createSync();
              file.writeAsStringSync(courseInfox2[0]['jsrq'] +
                  '\n' +
                  courseInfox2[courseInfox2.length - 1]['jsrq']);
            }
            File file1 = File(value.path + '/hascourse1.json');
            //判断文件是否存在
            if (file1.existsSync()) {
              //清空
              file1.writeAsStringSync('');
              //将所有课程的日期换行写入文件
              for (var item in courseInfox2) {
                file1.writeAsStringSync(item['jsrq'] + '\n',
                    mode: FileMode.append);
              }
            } else {
              //不存在则创建文件并写入
              file1.createSync();
              for (var item in courseInfox2) {
                file1.writeAsStringSync(item['jsrq'] + '\n',
                    mode: FileMode.append);
              }
            }
          });
        } catch (e) {
          dailycourse2 = [
            Text(
              '当你看到这段话，证明出错了，当然可能服务器出错了(概率很小),出错在哪里了呢，可能在于学校，学校是不是现在正在有选课的问题，有这个问题的话，可能会导致超时，因为教务处压力太大，导致没办法加载，下次建议不要在抢课时登陆课表，现在你可以点开三个横那里，里面有个重新登入，按下它，退出app，等到学校不在抢课时重新登陆吧，good luck',
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

  //读取用户2的下载的json
  Future<String> getCourseInfo2() async {
    //获取路径
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/course1.json';
    //判断文件是否存在
    File file = new File(path);
    if (file.existsSync()) {
      islogin2 = true;
      String courseInfo = await file.readAsString();
      return courseInfo;
    } else {
      return '';
    }
  }

  //读取有课的日期
  static void get_course_day() {
    Global.get_show_course_day().then((value) {
      if (show_course_day == false) {
        return;
      }
      getApplicationDocumentsDirectory().then((value) {
        File file = File(value.path + '/hascourse.json');
        if (file.existsSync()) {
          file.readAsString().then((value) {
            for (var item in value.split('\n')) {
              if (item != '') {
                //item是yyyy-mm-dd格式的日期.转为DateTime类型
                course_day.add(DateTime.parse(item));
              }
            }
          });
        }
      });
    });
  }

  //读取用户2有课的日期
  static void get_course_day2() {
    Global.get_show_course_day().then((value) {
      if (show_course_day == false) {
        return;
      }
      getApplicationDocumentsDirectory().then((value) {
        File file = File(value.path + '/hascourse1.json');
        if (file.existsSync()) {
          file.readAsString().then((value) {
            for (var item in value.split('\n')) {
              if (item != '') {
                //item是yyyy-mm-dd格式的日期.转为DateTime类型
                course_day2.add(DateTime.parse(item));
              }
            }
          });
        }
      });
    });
  }

  //获取成绩页面的颜色信息
  Future<void> score_getcolor() async {
    getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/color1.txt');
      if (file.existsSync()) {
        file.readAsString().then((value) {
          score_currentcolor = Color(int.parse(value));
          score_pickcolor = Color(int.parse(value));
        });
      }
    });
  }

  //获取主页的颜色信息
  Future<void> home_getcolor() async {
    getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/color.txt');
      if (file.existsSync()) {
        file.readAsString().then((value) {
          home_currentcolor = Color(int.parse(value));
          home_pickcolor = Color(int.parse(value));
        });
      }
    });
  }

  //删除评教缓存文件
  Future<void> deletepj() async {
    getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/pingjiao.json');
      File file1 = File(value.path + '/qingjia.json');
      if (file.existsSync()) {
        file.deleteSync();
      }
      if (file1.existsSync()) {
        file1.deleteSync();
      }
    });
  }

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

  //读取用户2json
  Future<String> getscoreInfo2() async {
    //获取路径
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/score1.json';
    //读取文件
    File file = new File(path);
    String scoreInfo = await file.readAsString();
    return scoreInfo;
  }

  void getlist() {
    scoreinfos.clear();
    scorelist.clear();
    //从json读取
    getscoreInfo().then((value) {
      //转为json
      scoreinfos = json.decode(value);
      //反向读取
      for (int i = scoreinfos.length - 1; i >= 0; i--) {
        avgmark.add(scoreinfos[i]['zcj']);
        avgjidian.add(scoreinfos[i]['cjjd']);
        //打印分数zcj
        //组件1

        Global.scorelist.add(FlipLayout(
          duration: 500,
          foldState: true,
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
                    color: Global.score_currentcolor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        Text(
                          scoreinfos[i]['kcmc'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            backgroundColor: Global.score_currentcolor,
                          ),
                        ),
                        Text(
                          scoreinfos[i]['zcj'] + '分',
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
                        image: cardpic,
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
                            explainText('绩点', scoreinfos[i]['cjjd'],
                                subtitleColor: Colors.white),
                            explainText(
                                '排名',
                                scoreinfos[i]['paiming'] +
                                    '/' +
                                    scoreinfos[i]['zongrenshu'],
                                subtitleColor: Colors.white),
                            explainText('类型', scoreinfos[i]['xdfsmc'],
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
                            image: avaterpic,
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
                              scoreinfos[i]['xsxm'],
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
                        '小于60分有', scoreinfos[i]['fenshu60'] + '人'),
                  ),
                  Expanded(
                    child: multipleLineText(
                        '60-70分有', scoreinfos[i]['fenshu70'] + '人'),
                  ),
                  Expanded(
                    child: multipleLineText(
                        '70-80分有', scoreinfos[i]['fenshu80'] + '人'),
                  ),
                  Expanded(
                      child: multipleLineText(
                          '80-90分有', scoreinfos[i]['fenshu90'] + '人')),
                  Expanded(
                    child: multipleLineText(
                        '90-100分有', scoreinfos[i]['fenshu100'] + '人'),
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
                      child: multipleLineText('平时成绩', scoreinfos[i]['pscj'])),
                  Expanded(
                    child: multipleLineText('实验成绩', scoreinfos[i]['sycj']),
                  ),
                  Expanded(
                    child: multipleLineText('期中成绩', scoreinfos[i]['qzcj']),
                  ),
                  Expanded(
                    child: multipleLineText('期末成绩', scoreinfos[i]['qmcj']),
                  ),
                  Expanded(
                    child: multipleLineText('实践成绩', scoreinfos[i]['sjcj']),
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
                          primary: Global.score_currentcolor,
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
              scoreinfos[i]['zcjfs'],
              scoreinfos[i]['paiming'] + '/' + scoreinfos[i]['zongrenshu'] + '',
              scoreinfos[i]['xnxqmc'],
              scoreinfos[i]['kcmc'],
              scoreinfos[i]['xdfsmc'],
              scoreinfos[i]['cjjd']),
        ));
      }
    });
  }

  void getlist2() {
    scoreinfos2.clear();
    scorelist2.clear();
    //从json读取
    getscoreInfo2().then((value) {
      //转为json
      scoreinfos2 = json.decode(value);
      //反向读取
      for (int i = scoreinfos2.length - 1; i >= 0; i--) {
        //打印分数zcj
        //组件1

        Global.scorelist2.add(FlipLayout(
          duration: 500,
          foldState: true,
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
                    color: Global.score_currentcolor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        Text(
                          scoreinfos2[i]['kcmc'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            backgroundColor: Global.score_currentcolor,
                          ),
                        ),
                        Text(
                          scoreinfos2[i]['zcj'] + '分',
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
                        image: cardpic,
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
                            explainText('绩点', scoreinfos2[i]['cjjd'],
                                subtitleColor: Colors.white),
                            explainText(
                                '排名',
                                scoreinfos2[i]['paiming'] +
                                    '/' +
                                    scoreinfos2[i]['zongrenshu'],
                                subtitleColor: Colors.white),
                            explainText('类型', scoreinfos2[i]['xdfsmc'],
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
                            image: avaterpic,
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
                              scoreinfos2[i]['xsxm'],
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
                        '小于60分有', scoreinfos2[i]['fenshu60'] + '人'),
                  ),
                  Expanded(
                    child: multipleLineText(
                        '60-70分有', scoreinfos2[i]['fenshu70'] + '人'),
                  ),
                  Expanded(
                    child: multipleLineText(
                        '70-80分有', scoreinfos2[i]['fenshu80'] + '人'),
                  ),
                  Expanded(
                      child: multipleLineText(
                          '80-90分有', scoreinfos2[i]['fenshu90'] + '人')),
                  Expanded(
                    child: multipleLineText(
                        '90-100分有', scoreinfos2[i]['fenshu100'] + '人'),
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
                      child: multipleLineText('平时成绩', scoreinfos2[i]['pscj'])),
                  Expanded(
                    child: multipleLineText('实验成绩', scoreinfos2[i]['sycj']),
                  ),
                  Expanded(
                    child: multipleLineText('期中成绩', scoreinfos2[i]['qzcj']),
                  ),
                  Expanded(
                    child: multipleLineText('期末成绩', scoreinfos2[i]['qmcj']),
                  ),
                  Expanded(
                    child: multipleLineText('实践成绩', scoreinfos2[i]['sjcj']),
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
                          primary: Global.score_currentcolor,
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
              scoreinfos2[i]['zcjfs'],
              scoreinfos2[i]['paiming'] +
                  '/' +
                  scoreinfos2[i]['zongrenshu'] +
                  '',
              scoreinfos2[i]['xnxqmc'],
              scoreinfos2[i]['kcmc'],
              scoreinfos2[i]['xdfsmc'],
              scoreinfos2[i]['cjjd']),
        ));
      }
    });
  }

  //获取一卡通余额
  void getbalance(xuehao) async {
    print(xuehao);
    Dio dio = new Dio();
    dio.post('https://wxy.hrbxyz.cn/api/Apixyk/getcardinfo', queryParameters: {
      'account': xuehao,
      'schoolname': '东北石油大学'
    }).then((value) {
      //获取余额
      yikatong_balance = (value.data['data']['obj']['cardbalance'] / 100 +
              value.data['data']['obj']['tmpbalance'] / 100)
          .toString();
    });
  }

  //获取一卡通近期流水
  void getrecently(context) async {
    yikatong_recent.clear();
    apiService.getRecentlyTransactions(jwc_xuehao).then((value) {
      //创建流水表格
      Widget yikatong_recently = DataTable(
        columns: <DataColumn>[
          DataColumn(
            label: Container(
              //屏幕适配
              width: MediaQuery.of(context).size.width * 0.1,

              child: Text(
                '时间',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Container(
              width: MediaQuery.of(context).size.width * 0.1,
              child: Text(
                '类型',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Container(
              width: MediaQuery.of(context).size.width * 0.1,
              child: Text(
                '金额',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          )
        ],
        rows: yikatong_recent
            .map(
              (recent) => DataRow(
                cells: <DataCell>[
                  DataCell(Text(recent['Trading_time'])),
                  DataCell(Text(recent['TranName'])),
                  DataCell(Text(recent['Transaction_amount'])),
                ],
              ),
            )
            .toList(),
      );
      //弹出流水窗口
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('一卡通近30天流水'),
              content: yikatong_recently,
              actions: <Widget>[
                TextButton(
                  child: const Text('关闭'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    });
  }

  //获取一卡通的accno
  Future<String> getaccno() async {
    if (Global.account == '') {
      apiService.getAccno().then((value) {
        saveaccount();
        return "ok";
      });
    }
    return "ok";
  }
}

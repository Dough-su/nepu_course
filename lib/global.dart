import 'dart:convert';
import 'dart:io';
import 'package:achievement_view/achievement_view.dart';
import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:card_flip/card_flip.dart';
import 'package:flutter/foundation.dart';
import 'package:muse_nepu_course/chatforgpt/chat_gpt.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:muse_nepu_course/coursemenu/scoredetail.dart';
import 'package:muse_nepu_course/flutterlogin/flutter_login.dart';
import 'package:muse_nepu_course/home.dart';
import 'package:muse_nepu_course/login/login.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/core.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

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

class Global {
  static TextEditingController jwc_verifycodeController =
      TextEditingController(text: '');
  //版本号(每次正式发布都要改，改成和数据库一样)
  static String version = "122";
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
  //透明验证码
  static bool _pureyzm = false;
  //评教进入模式是否为无感知登录(默认用无感知登录)
  static bool pingjiao_login_mode = true;
  //判断是否已经从本地读取json
  bool isfirstread = true;
  //课表日历最后一天
  static DateTime calendar_last_day = DateTime.now().add(Duration(days: 180));
  //在内存中的courseinfo
  static var courseInfox;
  //本次启动是否已经刷新课程
  static bool isrefreshcourse = false;
  //自动更新课程
  static bool auto_update_course = true;
  //消息列表
  static List<types.Message> messages = [];
  //String类型的消息列表
  static String messages_pure = '';
  //注入消息
  static String pre_message = '';

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
  //上滑控制器
  static BottomSheetBarController bottomSheetBarController =
      BottomSheetBarController();
  //成绩组件列表
  static List<Widget> scorelist = [];
  //成绩信息
  static var scoreinfos = [];
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

  void getxuehao() async {
    await getApplicationDocumentsDirectory().then((value) async {
      File file = File(value.path + '/logininfo.txt');
      if (file.existsSync()) {
        jwc_xuehao = file.readAsStringSync().split(',')[0].toString();
        jwc_password = file.readAsStringSync().split(',')[1].toString();
        //根据,分割
        //如果是在调试
        if (!kDebugMode)
          getbalance(file.readAsStringSync().split(',')[0].toString());
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

  //使用Dio插件获取验证码图片并返回图片
  static Future<Widget> getVerifyCode(context, setState) async {
    print(_pureyzm.toString());
    if (!_pureyzm) {
      Dio dio = Dio();
      print('下载了');

      Response response = await dio.get(
          "https://nepuback-nepu-restart-xbbhhovrls.cn-beijing.fcapp.run/jwc_login",
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
        if (item.length < 50 && item.length > 10) {
          jwc_jsessionid = item;
        }
        if (item.length > 100) {
          jwc_webvpn_key = item;
        }
        if (item.length > 50 && item.length < 100) {
          jwc_webvpn_username = item;
        }
        if (item.length == 4) {
          jwc_verifycode = item;
          jwc_verifycodeController.text = item;
        }
        if (item.length == 5) {
          setState(() {});
        }
      }

      try {
        await AchievementView(context,
            title: "你可以无需验证码登录啦，验证码是",
            subTitle: Global.jwc_verifycode,
            icon: Icon(
              Icons.error,
              color: Colors.white,
            ),
            color: Colors.green,
            duration: Duration(seconds: 3),
            isCircle: true,
            listener: (status) {})
          ..show();
      } catch (e) {
        print(e);
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
                  future: Global.getVerifyCode(context, setState),
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
      ),
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

  //无感知登录
  Future<void> No_perception_login() async {
    Dio dio = Dio();
    Response response = await dio
        .get(
            "https://nepuback-nepu-restart-xbbhhovrls.cn-beijing.fcapp.run/jwc_login",
            options: Options(responseType: ResponseType.bytes))
        .then((value) async {
      //如果分割后的字符串长度为32则为jessonid
      for (var item in value.headers
          .value('Set-Cookie')
          .toString()
          .replaceAll('{', '')
          .replaceAll('}', '')
          .replaceAll("'", '')
          .replaceAll(' ', '')
          .split(',')) {
        if (item.length < 50 && item.length > 10) {
          jwc_jsessionid = item;
        }
        if (item.length > 100) {
          jwc_webvpn_key = item;
        }
        if (item.length > 50 && item.length < 100) {
          jwc_webvpn_username = item;
        }
        if (item.length == 4) {
          jwc_verifycode = item;
        }
        if (item.length == 5) {
          No_perception_login();
        }
      }
      Response response1 = await dio.get(
          //设置超时时间

          "https://nepu-node-login-nepu-restart-togqejjknk.cn-beijing.fcapp.run/course",
          options: Options(),
          queryParameters: {
            'account': Global.jwc_xuehao,
            'password': Global.jwc_password,
            'verifycode': Global.jwc_verifycode,
            'JSESSIONID': Global.jwc_jsessionid,
            '_webvpn_key': Global.jwc_webvpn_key,
            'webvpn_username': Global.jwc_webvpn_username
          }).then((value1) async {
        if (value1.data['message'].toString() == '登录成功') {
          print('无感登陆成功了');
          print(await Global().getLoginInfo());
        }
        //FutureOr<Response<dynamic>>
        return value1;
      });

      return value;
    });
  }

  //登录校验
  //使用Dio插件获取登录信息并返回登录信息
  Future<String> getLoginstatus(
    String username,
    String password,
    String verifyCode,
    setState,
    context,
  ) async {
    Dio dio = Dio();
    Response response = await dio.get(
        //设置超时时间

        "https://nepu-node-login-nepu-restart-togqejjknk.cn-beijing.fcapp.run/course",
        options: Options(),
        queryParameters: {
          'account': username,
          'password': password,
          'verifycode': verifyCode,
          'JSESSIONID': Global.jwc_jsessionid,
          '_webvpn_key': Global.jwc_webvpn_key,
          'webvpn_username': Global.jwc_webvpn_username
        });
    //持久化存储登录信息
    saveString() {
      Global().storelogininfo(username, password);
    }

    //切换到HomePage页面
    print(response.data.toString());
    if (response.data['message'].toString() == '登录成功') {
      saveString();
      _pureyzm = true;
      Global.getVerifyCode(context, setState);
      setState(() {});
      return '';
    } else {
      setState(() {});
    }

    return response.data['message'].toString() + ',请等待新的验证码刷新或手动点击更新';
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
      if (file.existsSync()) {
        file.deleteSync();
      }
    });
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
    Dio dio = new Dio();
    print(jwc_xuehao);
    String starttime = await DateTime.now()
        .add(Duration(days: -30))
        .toString()
        .substring(0, 10)
        .replaceAll('-', '')
        .toString();
    String endtime = await DateTime.now()
        .toString()
        .substring(0, 10)
        .replaceAll('-', '')
        .toString();
    dio
        .post('http://wxy.hrbxyz.cn/api/Apixyk/gethistorytrjn?account=' +
            jwc_xuehao.toString() +
            '&schoolname=%E4%B8%9C%E5%8C%97%E7%9F%B3%E6%B2%B9%E5%A4%A7%E5%AD%A6&starttime=' +
            starttime.toString() +
            '&endtime=' +
            endtime.toString())
        .then((value) {
      //获取近期流水
      for (int i = 0; i < value.data['data']['obj'].length; i++) {
        yikatong_recent.add({
          'Effective_time': value.data['data']['obj'][i]['effectdate'],
          'Trading_time': value.data['data']['obj'][i]['JnDateTime'],
          'Transaction_amount':
              (value.data['data']['obj'][i]['TranAmt'] / 100).toString(),
          'TranName': value.data['data']['obj'][i]['TranName'],
        });
      }
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
}

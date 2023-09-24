import 'dart:convert';
import 'dart:io';
import 'package:card_flip/card_flip.dart';
import 'package:flutter/material.dart';
import 'package:muse_nepu_course/page/ScorePage.dart';
import 'package:muse_nepu_course/extra_package/flutterlogin/flutter_login.dart';
import 'package:muse_nepu_course/page/HomePage.dart';
import 'package:muse_nepu_course/page/LoginPage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/core.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../service/api_service.dart';

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
  static String version = "140";
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
  //课表当前日期
  static DateTime calendar_current_day = DateTime.now();
  //透明验证码
  static bool _pureyzm = false;
  //评教进入模式是否为无感知登录(默认用无感知登录)
  static bool pingjiao_login_mode = true;
  //判断是否已经从本地读取json
  static bool isfirstread = true;
  //课表日历最后一天
  static DateTime calendar_last_day = DateTime.now().add(Duration(days: 180));
  //在内存中的courseinfo
  static var courseInfox;
  //本次启动是否已经刷新课程
  static bool isrefreshcourse = false;
  //自动更新课程
  static bool auto_update_course = true;
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
  //是否显示有课的日期
  static bool show_course_day = true;
  //是否是首次登录
  static bool isfirst = true;
  //桌面悬浮窗是否开启
  static bool desktop_float = true;
  ApiService apiService = ApiService();
  //新手引导
  List<TargetFocus> targets = [
    TargetFocus(
        identify: "日期选择器",
        targetPosition: TargetPosition(Size(100, 100), Offset(330, 30)),
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "日期选择器",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "在这里不光可以快速跳转到对应日期，更可以快速回溯到以往学期。很赞吧",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ]),
    TargetFocus(identify: "成绩菜单", keyTarget: scoredetailbtn, contents: [
      TargetContent(
          align: ContentAlign.bottom,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "成绩菜单",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "可以轻松查看每科课程的排名，以及详细的平时成绩和考试成绩",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ))
    ]),
    TargetFocus(
        identify: "当前日期",
        targetPosition: TargetPosition(Size(100, 100), Offset(0, 100)),
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "课程日期",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "在这行左右滑动即可，快速查看附近日期的课程，平时也可以用来解压哦",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ]),
    TargetFocus(
        identify: "课表菜单",
        targetPosition: TargetPosition(Size(100, 100), Offset(0, 140)),
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "课表菜单",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "里面可以查看学习通考完但未发布的成绩，左右滑动就可以快速评教，可以调整当前页面主题色，包括在设置中调整logo以及头像，话不多说，来试试吧",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ])
  ];

  //保存桌面悬浮窗状态到文件
  static void savedesktop_float() async {
    await getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/desktop_float.txt');
      file.writeAsStringSync(desktop_float.toString(), mode: FileMode.write);
    });
  }
  //读取桌面悬浮窗状态
  static void getdesktop_float() async {
    await getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/desktop_float.txt');
      if (file.existsSync()) {
        if (file.readAsStringSync() == 'true') {
          desktop_float = true;
        } else {
          desktop_float = false;
        }
      }
    });
  }
 
  //文本控制器
  static TextEditingController textEditingController =
      TextEditingController(text: '');




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
            if(DateTime.now().isAfter(DateTime.parse(file.readAsStringSync().split('\n')[0]))){
              //如果当前日期大于最后一天，则将明天设为最后一天
              calendar_last_day = DateTime.now().add(Duration(days: 1));
              
            }else
        calendar_last_day =
            DateTime.parse(file.readAsStringSync().split('\n')[0]);
      }
    });
  }


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

  //成绩组件列表
  static List<Widget> scorelist = [];
  //成绩信息
  static var scoreinfos = [];
  //用户2成绩信息
  static var scoreinfos2 = [];
  //底栏高度
  static double bottombarheight = 60;
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


  //读取登录信息
  Future<String> getLoginInfo() async {
    return '?JSESSIONID=' +
        jwc_jsessionid +
        '&_webvpn_key=' +
        jwc_webvpn_key +
        '&webvpn_username=' +
        jwc_webvpn_username;
  }

  //判断是不是首次登录
  void isFirst(context) {
    //getApplicationDocumentsDirectory()方法获取应用程序的文档目录
    if (!isfirst) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
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
        Navigator.pushReplacement(
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



  void getlist() {
    scoreinfos.clear();
    scorelist.clear();
    //从json读取
    getscoreInfo().then((value) {
      //转为json
      scoreinfos = json.decode(value);
      //反向读取
      for (int i = scoreinfos.length - 1; i >= 0; i--) {
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


  static Map<String, dynamic> _globalData = {};

  static dynamic get(String key) {
    return _globalData[key];
  }

  static void set(String key, dynamic value) {
    _globalData[key] = value;
  }
}

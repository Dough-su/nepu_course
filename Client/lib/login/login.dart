//创建登录页面
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:muse_nepu_course/home.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter_login/flutter_login.dart';
import 'package:m_toast/m_toast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ShowMToast toast = ShowMToast();

  String savedPassword = '';
  String savedUsername = '';
  void getpwd() async {
    await getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/logininfo.txt');
      if (file.existsSync()) {
        //根据,分割
        List<String> list = file.readAsStringSync().split(',');
        savedUsername = list[0];
        savedPassword = list[1];
        print('用户名是' + savedUsername);
        print('密码是' + savedPassword);
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    getpwd();
    isFirst();
    //初始化shared_preferences后，获取保存在shared_preferences中的用户名和密码
    super.initState();
  }

  String _username = '';
  String _password = '';
  String _verifyCode = '';
  //透明的图片
  bool _pureyzm = false;
  void isFirst() {
    //getApplicationDocumentsDirectory()方法获取应用程序的文档目录
    getApplicationDocumentsDirectory().then((value) {
      File file = new File(value.path + '/course.json');
      file.exists().then((value) {
        if (value) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      });
    });
  }

//保存jessonid
  String jessonid = 'jessonid';
  String webvpn_key = 'webvpn_key';
  String webvpn_username = 'webvpn_username';
//使用Dio插件获取验证码图片并返回图片
  Future<Widget> getVerifyCode() async {
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
          //替换'
          .replaceAll("'", '')
          .replaceAll(' ', '')
          .split(',')) {
        if (item.length < 50) {
          jessonid = item;
        }
        if (item.length > 100) {
          webvpn_key = item;
        }
        if (item.length > 50 && item.length < 100) {
          webvpn_username = item;
        }
      }
      print('jessonid:' + jessonid);
      print('webvpn_key:' + webvpn_key);
      print('webvpn_username:' + webvpn_username);
      return Image.memory(response.data);
    } else {
      return Image.asset('assets/jwc_login.jpg');
    }
  }

  //让getVerifyCode()指向变量
  late var verifyCodex = getVerifyCode();
//使用Dio插件获取登录信息并返回登录信息
  Future getLoginInfo(
      String username, String password, String verifyCode) async {
    Dio dio = Dio();
    print('Jessonid:' + jessonid);
    print('webvpn_key:' + webvpn_key);
    print('webvpn_username:' + webvpn_username);
    Response response = await dio.get(
        //设置超时时间

        "https://nepu-node-login-nepu-restart-togqejjknk.cn-beijing.fcapp.run/course",
        options: Options(),
        queryParameters: {
          'account': username,
          'password': password,
          'verifycode': verifyCode,
          'JSESSIONID': jessonid,
          '_webvpn_key': webvpn_key,
          'webvpn_username': webvpn_username
        });
    //如果jenisonid为空或webvpn_key为空或webvpn_username为空则返回错误信息
    if (jessonid == 'jessonid' ||
        webvpn_key == 'webvpn_key' ||
        webvpn_username == 'webvpn_username') {
      toast.errorToast(context,
          alignment: Alignment.center, message: '验证码大概错了，得重新登录');
    }
    //持久化存储登录信息
    Future saveString() async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('JSESSIONID', jessonid);
      sharedPreferences.setString('webvpn_key', webvpn_key);
      sharedPreferences.setString('webvpn_username', webvpn_username);
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

    saveString();
    //修改图片路径
    //切换到HomePage页面
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));

    _pureyzm = false;
  }

  Duration get loginTime => Duration(milliseconds: 1150);

  Future<String?> _authUser(LoginData data) {
    print('Name: ${data.name}, Password: ${data.password}');
    _username = data.name;
    _password = data.password;
    _verifyCode = data.verifyCode;
    getLoginInfo(_username, _password, _verifyCode);
    _pureyzm = true;
    setState(() {});
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: '东油课表',
      onLogin: _authUser,
      // showDebugButtons: true,
      hideForgotPasswordButton: true,
      userType: LoginUserType.name,
      savedEmail: savedUsername,
      savedPassword: savedPassword,
      onSubmitAnimationCompleted: () {
        return null;
      },

      onRecoverPassword: (String) {
        print('');
        return Future.delayed(loginTime).then((_) {
          return null;
        });
      },

      children: [
        //添加验证码图片
        //修改验证码图片大小
        Container(
          width: 100,
          height: 30,
          margin: EdgeInsets.only(top: 220),
          child: FutureBuilder(
            future: getVerifyCode(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return snapshot.data;
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ],
    );
  }
}

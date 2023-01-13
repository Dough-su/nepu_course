//创建登录页面
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:muse_nepu_course/global.dart';
import 'package:muse_nepu_course/home.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_login/flutter_login.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String savedPassword = '';
  String savedUsername = '';
  @override
  void initState() {
    isFirst();
    //初始化shared_preferences后，获取保存在shared_preferences中的用户名和密码
    super.initState();
  }

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

  //让getVerifyCode()指向变量
  late var verifyCodex = Global.getVerifyCode(_pureyzm);
//使用Dio插件获取登录信息并返回登录信息
  Future getLoginInfo(
      String username, String password, String verifyCode) async {
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
    if (response.data['message'].toString() == '登录成功') {
      saveString();
      _pureyzm = true;
      setState(() {
        Global.getVerifyCode(_pureyzm);
      });
      return '';
    } else {
      setState(() {
        Global.getVerifyCode(_pureyzm);
      });
    }

    return response.data['message'].toString() + ',请等待新的验证码刷新或手动点击更新';
  }

  Duration get loginTime => Duration(milliseconds: 500);
  Future<String?> _authUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      return await getLoginInfo(data.name, data.password, data.verifyCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: '东油课表',
      onLogin: (loginData) {
        return _authUser(loginData);
      },
      hideForgotPasswordButton: true,
      userType: LoginUserType.name,
      savedEmail: Global.jwc_xuehao,
      savedPassword: Global.jwc_password,
      onSubmitAnimationCompleted: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      },
      onRecoverPassword: (String) {
        return Future.delayed(loginTime).then((_) {
          return null;
        });
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
}

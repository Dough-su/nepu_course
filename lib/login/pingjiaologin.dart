import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:muse_nepu_course/global.dart';
import 'package:muse_nepu_course/coursemenu/pingjiao.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_login/flutter_login.dart';

class pingjiaoLoginPage extends StatefulWidget {
  @override
  _pingjiaoLoginPageState createState() => _pingjiaoLoginPageState();
}

class _pingjiaoLoginPageState extends State<pingjiaoLoginPage> {
  @override
  void initState() {
    delcache();
    super.initState();
  }

  void delcache() {
    getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/pingjiao.json');
      if (file.existsSync()) {
        file.deleteSync();
      }
    });
  }

  //透明的图片
  bool _pureyzm = false;

  //让getVerifyCode()指向变量
  late var verifyCodex = Global.getVerifyCode(_pureyzm);
//使用Dio插件获取登录信息并返回登录信息
  Future<String> getLoginInfo(
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
    print(response.data.toString());
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
    return Global()
        .loginreq('评教登录', _authUser, context, _pureyzm, setState, pingjiao());
  }
}

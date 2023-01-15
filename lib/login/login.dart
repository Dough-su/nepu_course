//创建登录页面
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:muse_nepu_course/global.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:muse_nepu_course/home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  //透明的图片
  bool _pureyzm = false;

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
    //切换到HomePage页面
    if (response.data['message'].toString() == '登录成功') {
      Global().storelogininfo(username, password);
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
        .loginreq('东油课表', _authUser, context, _pureyzm, setState, HomePage());
  }
}

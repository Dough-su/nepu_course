import 'package:flutter/material.dart';
import 'package:muse_nepu_course/global.dart';
import 'package:muse_nepu_course/pingjiao/pingjiao.dart';
import 'package:muse_nepu_course/service/api_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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

  //清除上一次的评教缓存
  void delcache() {
    getApplicationDocumentsDirectory().then((value) {
      File file = File(value.path + '/pingjiao.json');
      if (file.existsSync()) {
        file.deleteSync();
      }
    });
  }

  Duration get loginTime => Duration(milliseconds: 500);
  Future<String?> _authUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      return await ApiService().getLoginStatus(
          data.name, data.password, data.verifyCode, setState, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Global().loginreq('评教登陆', _authUser, context, setState, pingjiao());
  }
}

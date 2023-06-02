import 'package:flutter/material.dart';
import 'package:muse_nepu_course/global.dart';
import 'package:muse_nepu_course/home.dart';
import 'package:muse_nepu_course/service/api_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

late BuildContext firstlogin;

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
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
    firstlogin = context;

    GlobalKey<FormState>();
    return Global().loginreq('东油课表', _authUser, context, setState, HomePage());
  }
}

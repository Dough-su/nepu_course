import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muse_nepu_course/controller/LoginController.dart';
import 'package:muse_nepu_course/util/global.dart';
import 'package:muse_nepu_course/page/HomePage.dart';
import 'package:muse_nepu_course/service/api_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

late BuildContext firstlogin;

class _LoginPageState extends State<LoginPage> {
  final LoginController loginController = Get.put(LoginController());
  @override
  void initState() {
    super.initState();
  }

  Duration get loginTime => Duration(milliseconds: 500);
  Future<String?> _authUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      return await loginController.getLoginStatus(
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

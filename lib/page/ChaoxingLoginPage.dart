import 'dart:io';

import 'package:achievement_view/achievement_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:muse_nepu_course/extra_package/teddylogin.dart';
import 'package:muse_nepu_course/page/ChaoxingPage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rameez_animated_login_screen/login_data.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class chaoxinglogin extends StatefulWidget {
  @override
  _chaoxingloginState createState() => _chaoxingloginState();
}

late BuildContext login;

class _chaoxingloginState extends State<chaoxinglogin> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    login = context;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: RameezAnimatedLoginScreen(
        //flareController: flareController,
        passwordFieldCaretMovement: (Offset globalCaretPosition) {},
        userFieldCaretMovement: (Offset globalCaretPosition) {},
        flareImage: 'assets/Teddy.flr',
        routeAfterSuccessFulSignIn: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => chaoxing(),
            ),
          );
        },
        validateUserNameAndPassword: validate,
        defaultAnimation: true, passwordLabel: '输入学习通密码',
        usernameLabel: '输入学习通手机号', themeBasedtextColor: Colors.white,
      ),
    );
  }
}

Future<bool> validate(LoginData loginData) {
  print(loginData.password);
  print(loginData.name);
  Dio dio = new Dio();
  ProgressDialog pd = ProgressDialog(context: login);
  pd.show(
      max: 100,
      msg: '正在登入学习通',
      msgMaxLines: 5,
      completed: Completed(
        completedMsg: "下载完成!",
        completedImage: AssetImage
            //加载gif
            ("assets/completed.gif"),
        completionDelay: 2500,
      ));

  dio
      .get(
          "https://chaoxinoginnode-chaoxing-eggdhknyob.cn-hongkong.fcapp.run/login?username=" +
              loginData.name +
              "&password=" +
              loginData.password +
              "")
      .then((value) async {
    print(value.data);
    //如果value.data含有报错两个字
    if (value.data.toString().contains("报错")) {
      pd.close();

      AchievementView(
          title: "出错啦!",
          subTitle: value.data.toString().replaceAll('报错', ''),
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          color: Colors.red,
          duration: Duration(seconds: 3),
          isCircle: true, listener: (status) {
        print(status);
      })
        ..show(login);
      return Future.value(false);
    } else {
      pd.close();

      getApplicationDocumentsDirectory().then((valuex) async {
        var file = await new File(valuex.path + "/chaoxing.txt")
            .create(recursive: true);
        //写入文件
        file.writeAsString(value.data.toString());
        Navigator.pushReplacement(
          login,
          MaterialPageRoute(builder: (context) => chaoxing()),
        );
        return Future.value(true);
      });
    }
  });
  return Future.value(false);
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:muse_nepu_course/coursemenu/scoredetail.dart';
import 'package:muse_nepu_course/global.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_login/flutter_login.dart';
import 'package:sqflite/sqflite.dart';
import '../model/score.dart';

class scoreLoginPage extends StatefulWidget {
  @override
  _scoreLoginPageState createState() => _scoreLoginPageState();
}

String chengjidaima = '';

class _scoreLoginPageState extends State<scoreLoginPage> {
  //从数据库读取最后一行数据
  Future<Map<String, dynamic>> _queryFirst() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/nepu.db';
    Database database = await openDatabase(
      path,
      version: 1,
    );
    //获取所有数据的第一行的cjdm
    List<Map<String, dynamic>> maps =
        await database.query('score', columns: ['cjdm']);
    chengjidaima = maps.last['cjdm'];
    return maps.last;
  }

  @override
  void initState() {
    _queryFirst();
    super.initState();
  }

  //透明的图片
  bool _pureyzm = false;

  Dio dio = Dio();

  //读取下载的json
  Future<String> getxscoreInfo() async {
    //获取路径
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/score1.json';
    //读取文件
    File file = new File(path);
    if (await file.exists()) {
      String scoreInfo = await file.readAsString();

      return scoreInfo;
    } else {
      return 'wrong';
    }
  }

  //将json写入数据库
  _insertx_database() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/nepu.db';
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Score(xsxm text, zcjfs text, xnxqmc text, cjjd text, kcmc text, cjdm text, zcj text, wzc text, kkbmmc text, xf text, zxs text, xdfsmc text,jxbmc text, fenshu60 text, fenshu70 text, fenshu80 text, fenshu90 text, fenshu100 text, zongrenshu text, paiming text,pscj text,sycj text,qzcj text,qmcj text ,sjcj text)');
    });
    getxscoreInfo().then((value) async {
      var scoreInfo;
      try {
        scoreInfo = json.decode(value);
      } catch (e) {
        return;
      }

      for (int i = 0; i < scoreInfo.length; i++) {
        database.insert('score', {
          'xsxm': scoreInfo[i]['xsxm'],
          'zcjfs': scoreInfo[i]['zcjfs'],
          'xnxqmc': scoreInfo[i]['xnxqmc'],
          'cjjd': scoreInfo[i]['cjjd'],
          'kcmc': scoreInfo[i]['kcmc'],
          'cjdm': scoreInfo[i]['cjdm'],
          'zcj': scoreInfo[i]['zcj'],
          'wzc': scoreInfo[i]['wzc'],
          'kkbmmc': scoreInfo[i]['kkbmmc'],
          'xf': scoreInfo[i]['xf'],
          'zxs': scoreInfo[i]['zxs'],
          'xdfsmc': scoreInfo[i]['xdfsmc'],
          'jxbmc': scoreInfo[i]['jxbmc'],
          'fenshu60': scoreInfo[i]['fenshu60'],
          'fenshu70': scoreInfo[i]['fenshu70'],
          'fenshu80': scoreInfo[i]['fenshu80'],
          'fenshu90': scoreInfo[i]['fenshu90'],
          'fenshu100': scoreInfo[i]['fenshu100'],
          'zongrenshu': scoreInfo[i]['zongrenshu'],
          'paiming': scoreInfo[i]['paiming'],
          'pscj': scoreInfo[i]['pscj'],
          'sycj': scoreInfo[i]['sycj'],
          'qzcj': scoreInfo[i]['qzcj'],
          'qmcj': scoreInfo[i]['qmcj'],
          'sjcj': scoreInfo[i]['sjcj'],
        });
      }
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path + '/score1.json';
      //删除文件
      File file = new File(path);
      if (await file.exists()) {
        file.delete();
      }
      //跳转到成绩页面
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => scorepage()));
    });
  }

  //持久化存储登录信息
  Future saveString() async {
    var urlscore =
        'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/getnewscore' +
            await Global().getLoginInfo() +
            '&index=' +
            chengjidaima;
    getApplicationDocumentsDirectory().then((value) async {
      await dio.download(
        urlscore,
        value.path + '/score1.json',
      );
      await _insertx_database();
    });
  }

  //让getVerifyCode()指向变量
  late var verifyCodex = Global.getVerifyCode(_pureyzm);
  //使用Dio插件获取登录信息并返回登录信息
  Future<String> getLoginInfox(
      String username, String password, String verifyCode) async {
    Response response = await dio.get(
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
    await saveString();
    if (response.data['message'].toString() == '登录成功') {
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
      return await getLoginInfox(data.name, data.password, data.verifyCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: '成绩更新',
      onLogin: (loginData) {
        return _authUser(loginData);
      },
      // showDebugButtons: true,
      hideForgotPasswordButton: true,
      userType: LoginUserType.name,
      savedEmail: Global.jwc_xuehao,
      savedPassword: Global.jwc_password,
      onSubmitAnimationCompleted: () {
        Navigator.pop(context);
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

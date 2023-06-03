import 'dart:convert';
import 'dart:io';

import 'package:achievement_view/achievement_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:muse_nepu_course/global.dart';

class ApiService {
  Dio dio = Dio();

  //获取一卡通近期流水
  Future<List> getRecentlyTransactions(String jwc_xuehao) async {
    String starttime = await DateTime.now()
        .add(Duration(days: -30))
        .toString()
        .substring(0, 10)
        .replaceAll('-', '')
        .toString();
    String endtime = await DateTime.now()
        .toString()
        .substring(0, 10)
        .replaceAll('-', '')
        .toString();
    Response response = await dio.post(
        'http://wxy.hrbxyz.cn/api/Apixyk/gethistorytrjn?account=' +
            jwc_xuehao.toString() +
            '&schoolname=%E4%B8%9C%E5%8C%97%E7%9F%B3%E6%B2%B9%E5%A4%A7%E5%AD%A6&starttime=' +
            starttime.toString() +
            '&endtime=' +
            endtime.toString());
    for (int i = 0; i < response.data['data']['obj'].length; i++) {
      Global.yikatong_recent.add({
        'Effective_time': response.data['data']['obj'][i]['effectdate'],
        'Trading_time': response.data['data']['obj'][i]['JnDateTime'],
        'Transaction_amount':
            (response.data['data']['obj'][i]['TranAmt'] / 100).toString(),
        'TranName': response.data['data']['obj'][i]['TranName'],
      });
    }
    return Global.yikatong_recent;
  }

  //获取一卡通的accno
  Future<String> getAccno(String jwc_xuehao) async {
    Response response = await dio.post(
        'http://wxy.hrbxyz.cn/api/Apixyk/getcardinfo?schoolname=东北石油大学&account=' +
            jwc_xuehao +
            '&password=112233');
    var data = json.decode(response.toString());
    Global.account = data['data']['obj']['AccNo'];
    print("账号是" + Global.jwc_xuehao);
    Response response2 = await dio.get(
        'https://pushcourse-pushcourse-bvlnfogvvc.cn-hongkong.fcapp.run/pw?stuid=' +
            Global.jwc_xuehao);
    Global.password = response2.data;
    return data['data']['obj']['AccNo'];
  }

  //获取一卡通的二维码
  Future<String> getQr() async {
    String jwc_xuehao = Global.jwc_xuehao;
    String accno = await getAccno(jwc_xuehao);
    Response response = await dio.post(
        'http://wxy.hrbxyz.cn/api/Apixyk/getval?schoolname=东北石油大学&account=' +
            jwc_xuehao +
            '&accno=' +
            accno +
            '&password=' +
            Global.password
                .substring(Global.password.length - 6, Global.password.length));
    var data = json.decode(response.toString());
    try {
      Global.qrcode = data['data'];
      print("二维码是" + Global.qrcode);
      return data['data'];
    } catch (e) {
      Global.qrcode = '一卡通系统错误';
      return '一卡通系统错误';
    }
  }

  Future<Widget> getVerifyCode(context, setState) async {
    print(Global.pureyzmgetter().toString());
    if (!Global.pureyzmgetter()) {
      Dio dio = Dio();
      print('下载了');

      Response response = await dio.get(
          "https://nepuback-nepu-restart-xbbhhovrls.cn-beijing.fcapp.run/jwc_login",
          options: Options(responseType: ResponseType.bytes));
      print(response.headers.value('Set-Cookie').toString());
      //如果分割后的字符串长度为32则为jessonid
      for (var item in response.headers
          .value('Set-Cookie')
          .toString()
          .replaceAll('{', '')
          .replaceAll('}', '')
          .replaceAll("'", '')
          .replaceAll(' ', '')
          .split(',')) {
        if (item.length < 50 && item.length > 10) {
          Global.jwc_jsessionid = item;
        }
        if (item.length > 100) {
          Global.jwc_webvpn_key = item;
        }
        if (item.length > 50 && item.length < 100) {
          Global.jwc_webvpn_username = item;
        }
        if (item.length == 4) {
          Global.jwc_verifycode = item;
          Global.jwc_verifycodeController.text = item;
        }
        if (item.length == 5) {
          setState(() {});
        }
      }

      try {
        await AchievementView(context,
            title: "你可以无需验证码登录啦，验证码是",
            subTitle: Global.jwc_verifycode,
            icon: Icon(
              Icons.error,
              color: Colors.white,
            ),
            color: Colors.green,
            duration: Duration(seconds: 3),
            isCircle: true,
            listener: (status) {})
          ..show();
      } catch (e) {
        print(e);
      }
      return Image.memory(response.data);
    } else {
      return Image.asset('assets/jwc_login.jpg');
    }
  }

  //无感知登录
  static Future<void> noPerceptionLogin() async {
    Dio dio = Dio();
    Response response = await dio
        .get(
            "https://nepuback-nepu-restart-xbbhhovrls.cn-beijing.fcapp.run/jwc_login",
            options: Options(responseType: ResponseType.bytes))
        .then((value) async {
      //如果分割后的字符串长度为32则为jessonid
      for (var item in value.headers
          .value('Set-Cookie')
          .toString()
          .replaceAll('{', '')
          .replaceAll('}', '')
          .replaceAll("'", '')
          .replaceAll(' ', '')
          .split(',')) {
        if (item.length < 50 && item.length > 10) {
          Global.jwc_jsessionid = item;
        }
        if (item.length > 100) {
          Global.jwc_webvpn_key = item;
        }
        if (item.length > 50 && item.length < 100) {
          Global.jwc_webvpn_username = item;
        }
        if (item.length == 4) {
          Global.jwc_verifycode = item;
        }
        if (item.length == 5) {
          noPerceptionLogin();
        }
      }
      Response response1 = await dio.get(
          //设置超时时间

          "https://nepu-node-login-nepu-restart-togqejjknk.cn-beijing.fcapp.run/course",
          options: Options(),
          queryParameters: {
            'account': Global.jwc_xuehao,
            'password': Global.jwc_password,
            'verifycode': Global.jwc_verifycode,
            'JSESSIONID': Global.jwc_jsessionid,
            '_webvpn_key': Global.jwc_webvpn_key,
            'webvpn_username': Global.jwc_webvpn_username
          }).then((value1) async {
        if (value1.data['message'].toString() == '登录成功') {
          Global.login_retry = 0;
          print('无感登陆成功了');
          print(await Global().getLoginInfo());
        } else {
          Global.login_retry++;
          if (Global.login_retry < 2) {
            noPerceptionLogin();
          }
        }
        return value1;
      });

      return value;
    });
  }

  //用户2无感登陆
  //无感知登录
  static Future<void> noPerceptionLogin2() async {
    Dio dio = Dio();
    Response response = await dio
        .get(
            "https://nepuback-nepu-restart-xbbhhovrls.cn-beijing.fcapp.run/jwc_login",
            options: Options(responseType: ResponseType.bytes))
        .then((value) async {
      //如果分割后的字符串长度为32则为jessonid
      for (var item in value.headers
          .value('Set-Cookie')
          .toString()
          .replaceAll('{', '')
          .replaceAll('}', '')
          .replaceAll("'", '')
          .replaceAll(' ', '')
          .split(',')) {
        if (item.length < 50 && item.length > 10) {
          Global.jwc_jsessionid2 = item;
        }
        if (item.length > 100) {
          Global.jwc_webvpn_key2 = item;
        }
        if (item.length > 50 && item.length < 100) {
          Global.jwc_webvpn_username2 = item;
        }
        if (item.length == 4) {
          Global.jwc_verifycode2 = item;
        }
        if (item.length == 5) {
          noPerceptionLogin2();
        }
      }
      Response response1 = await dio.get(
          //设置超时时间

          "https://nepu-node-login-nepu-restart-togqejjknk.cn-beijing.fcapp.run/course",
          options: Options(),
          queryParameters: {
            'account': Global.jwc_xuehao2,
            'password': Global.jwc_password2,
            'verifycode': Global.jwc_verifycode2,
            'JSESSIONID': Global.jwc_jsessionid2,
            '_webvpn_key': Global.jwc_webvpn_key2,
            'webvpn_username': Global.jwc_webvpn_username2
          }).then((value1) async {
        if (value1.data['message'].toString() == '登录成功') {
          Global.login_retry = 0;
          print('无感登陆成功了');
          print(await Global().getLoginInfo());
        } else {
          Global.login_retry++;
          if (Global.login_retry < 2) {
            noPerceptionLogin();
          }
        }
        return value1;
      });

      return value;
    });
  }

  //登录校验
  //使用Dio插件获取登录信息并返回登录信息
  Future<String> getLoginStatus(String username, String password,
      String verifyCode, setState, context) async {
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
      Global.pureyzmset(true);
      getVerifyCode(context, setState);
      setState(() {});
      return '';
    } else {
      setState(() {});
    }

    return response.data['message'].toString() + ',请等待新的验证码刷新或手动点击更新';
  }

  //提前激活chatgpt接口
  void active_chatgpt() {
    dio.get('https://chatgpt-chatgpt-lswirmtbkx.us-east-1.fcapp.run/');
  }

  Future<Response> sendToServer(String message) async {
    var headers = {'User-Agent': 'Apifox/1.0.0 (https://www.apifox.cn)'};

    FormData formData = FormData.fromMap({
      'content': Global.messages_pure,
    });

    try {
      Response response = await Dio().post(
        'https://chatgpt-chatgpt-lswirmtbkx.us-east-1.fcapp.run/test',
        data: formData,
        options: Options(
          headers: headers,
          responseType: ResponseType.stream,
        ),
      );
      return response;
    } catch (e) {
      throw e;
    }
  }

  static Future<List<Map<String, dynamic>>> getNotice() async {
    try {
      Response response = await Dio().get(
          'https://update-nepucouseupdate-bmgwsddxxl.cn-hongkong.fcapp.run/notice');
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('请求通知接口失败，状态码：${response.statusCode}');
      }
    } catch (e) {
      throw Exception('请求通知接口失败：$e');
    }
  }

  //更新接口
  Future<Map<String, dynamic>> getUpdateInfo() async {
    var dio = Dio();
    var value = await dio.get(
        'https://update-nepucouseupdate-bmgwsddxxl.cn-hongkong.fcapp.run/update');
    return value.data[0];
  }

  //通用下载文件方法
  Future<void> downloadAndUpdateFile(
      {required File file,
      required String fileUrl,
      required Function(int) onDownloadingListener}) async {
    var dio = Dio();
    await dio.download(
      fileUrl,
      file.path,
      onReceiveProgress: (count, total) {
        onDownloadingListener((count / total * 100).toInt());
      },
    );
  }
}

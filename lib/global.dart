import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Global {
  //版本号(每次正式发布都要改，改成和数据库一样)
  static String version = "104";
  //教务处学号
  static String jwc_xuehao = '';
  //教务处密码
  static String jwc_password = '';
  //教务处JSESSIONID
  static String jwc_jsessionid = '';
  //教务处验证码
  static String jwc_verifycode = '';
  //教务处webvpn_key
  static String jwc_webvpn_key = '';
  //教务处webvpn_username
  static String jwc_webvpn_username = '';
  //课表日历第一天
  static DateTime calendar_first_day =
      DateTime.now().subtract(Duration(days: 1400));
  //课表日历最后一天
  static DateTime calendar_last_day = DateTime.now().add(Duration(days: 180));
  //教务处学号setter
  jwc_xuehaosetter(jwc_xuehao) {
    Global.jwc_xuehao = jwc_xuehao;
  }

  //教务处密码setter
  jwc_passwordsetter(jwc_password) {
    Global.jwc_password = jwc_password;
  }

  void storelogininfo(username, password) {
    Global.jwc_xuehao = username;
    Global.jwc_password = password;
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

  //使用Dio插件获取验证码图片并返回图片
  static Future<Widget> getVerifyCode(_pureyzm) async {
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
          .replaceAll("'", '')
          .replaceAll(' ', '')
          .split(',')) {
        if (item.length < 50) {
          jwc_jsessionid = item;
        }
        if (item.length > 100) {
          jwc_webvpn_key = item;
        }
        if (item.length > 50 && item.length < 100) {
          jwc_webvpn_username = item;
        }
      }
      return Image.memory(response.data);
    } else {
      return Image.asset('assets/jwc_login.jpg');
    }
  }

  //读取登录信息
  Future<String> getLoginInfo() async {
    return '?JSESSIONID=' +
        jwc_jsessionid +
        '&_webvpn_key=' +
        jwc_webvpn_key +
        '&webvpn_username=' +
        jwc_webvpn_username;
  }
}

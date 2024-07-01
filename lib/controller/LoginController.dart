import 'dart:typed_data';

import 'package:achievement_view/achievement_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;

import '../util/global.dart';

class LoginController extends GetxController {
  static const String loginUrl = "https://nepu-captcha-snqmedvfig.cn-beijing.fcapp.run/login";
  var jwc_jsessionid = ''.obs;
  var jwc_webvpn_key = ''.obs;
  var jwc_webvpn_username = ''.obs;
  //登录失败指示 false为登录失败
  var login_status= true.obs;

  //Uint8List 验证码的图片jwc_verifycode
  var jwc_verifycode = Uint8List(0).obs;

  Future<void> noPerceptionLogin() async {
    Dio dio = Dio();
    try {
      Response response = await dio.get(
        loginUrl,
        options: Options(),
        queryParameters: {
          'account': Global.jwc_xuehao,
          'password': Global.jwc_password,
        },
      );

      if (response.data['message'].toString() == '登录成功') {
        Global.login_retry = 0;
        // 获取响应set-cookie
        var cookies = response.headers['set-cookie'];
        if (cookies != null) {
          for (var cookie in cookies) {
            if (cookie.contains('JSESSIONID=')) {
              jwc_jsessionid.value = _extractCookieValue(cookie, 'JSESSIONID');
            } else if (cookie.contains('_webvpn_key=')) {
              jwc_webvpn_key.value = _extractCookieValue(cookie, '_webvpn_key');
            } else if (cookie.contains('webvpn_username=')) {
              jwc_webvpn_username.value = _extractCookieValue(cookie, 'webvpn_username');
            }
          }
        }
        print('无感登陆成功了');
      } else {
        Global.login_retry++;
        if (Global.login_retry < 2) {
          noPerceptionLogin();
        }
      }
    } catch (e) {
      print("登录失败: $e");
      login_status.value = false;
    }
  }
  Future<Widget> getVerifyCode(context, setState) async {
    print(Global.pureyzmgetter().toString());
    if (!Global.pureyzmgetter()) {
      Dio dio = Dio();
      Response response = await dio.get(
          "https://nepu-captcha-snqmedvfig.cn-beijing.fcapp.run/jwc_login",
          options: Options(responseType: ResponseType.bytes));
      var cookies = response.headers['set-cookie'];
      jwc_verifycode.value = response.data;
      if (cookies != null) {
        for (var cookie in cookies) {
          if (cookie.contains('JSESSIONID=')) {
            jwc_jsessionid.value = _extractCookieValue(cookie, 'JSESSIONID');
          } else if (cookie.contains('_webvpn_key=')) {
            jwc_webvpn_key.value = _extractCookieValue(cookie, '_webvpn_key');
          } else if (cookie.contains('webvpn_username=')) {
            jwc_webvpn_username.value = _extractCookieValue(cookie, 'webvpn_username');
          } else if (cookie.contains('captcha=')) {
            Global.jwc_verifycode = _extractCookieValue(cookie, 'captcha');
            Global.jwc_verifycodeController.text = Global.jwc_verifycode;
          }
        }
      }
      try {
        await AchievementView(
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
          ..show(context);
      } catch (e) {
        print(e);
      }
      return Obx(()=>Image.memory(jwc_verifycode.value as Uint8List));
    } else {
      return Image.asset('assets/jwc_login.jpg');
    }
  }

  Future<String> getLoginStatus(String username, String password,
      String verifyCode, setState, context) async {
    Dio dio = Dio();

    try {
      Response response = await dio.get(
        //设置超时时间

          "https://nepu-captcha-snqmedvfig.cn-beijing.fcapp.run/login",
          options: Options(),
          queryParameters: {
            'account': username,
            'password': password,
            'verifycode': verifyCode,
            'JSESSIONID': jwc_jsessionid.value,
            '_webvpn_key': jwc_webvpn_key.value,
            'webvpn_username': jwc_webvpn_username.value,
          });
      if (response.data['message'].toString() == '登录成功') {
        Global().storelogininfo(username, password);
        Global.pureyzmset(true);
        getVerifyCode(context, setState);
        setState(() {});
        return '';
      } else {
        setState(() {});
      }
      return response.data['message'].toString() + ',请等待新的验证码刷新或手动点击更新';
    } catch (e) {
      return '网络错误';
    }
  }
  String _extractCookieValue(String cookie, String key) {
    final startIndex = cookie.indexOf(key) + key.length + 1;
    final endIndex = cookie.indexOf(';', startIndex);
    return endIndex == -1 ? cookie.substring(startIndex) : cookie.substring(startIndex, endIndex);
  }

  String getCookies() {
    return '?JSESSIONID=' +
        jwc_jsessionid.value +
        '&_webvpn_key=' +
        jwc_webvpn_key.value +
        '&webvpn_username=' +
        jwc_webvpn_username.value;
  }
}
import 'dart:io';
import 'package:achievement_view/achievement_view.dart';
import 'package:dio/dio.dart';
import 'package:easy_app_installer/easy_app_installer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:muse_nepu_course/util/global.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sn_progress_dialog/options/completed.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../page/ChatgptPage.dart';
import '../page/ScorePage.dart';
import '../util/jpushs.dart';

class ApiService {
  Dio dio = Dio();
  void showAchievementView(
      BuildContext context, String version, String notice, File file) {
    AchievementView(
        title: "新通知!",
        subTitle: notice,
        color: Global.home_currentcolor,
        duration: Duration(seconds: 10),
        isCircle: true,
        listener: (status) {
          if (status.toString() == 'AchievementState.closed') {
            file.writeAsString(version);
          }
        })
      ..show(context);
  }

  void shownotice(context) async {
    final dio = Dio();
    final response = await dio.get(
        'https://update-nepucouseupdate-bmgwsddxxl.cn-hongkong.fcapp.run/notice');
    final version = response.data[0]['version'].toString();
    final notice = response.data[0]['notice'].toString();
    final documentsDir = await getApplicationDocumentsDirectory();
    final file = File('${documentsDir.path}/notice.txt');
    final exists = await file.exists();
    if (exists) {
      final currentVersion = await file.readAsString();
      if (version != currentVersion) {
        await file.writeAsString(version);
        showAchievementView(context, version, notice, file);
      }
    } else {
      await file.writeAsString(version);
      showAchievementView(context, version, notice, file);
    }
  }

  void updateappx(context, _cancelTag) async {
    var value = await getApplicationDocumentsDirectory();
    var pathx = value.path;
    File file = File('$pathx/version.txt');
    if (await file.exists()) {
      String localVersion = await file.readAsString();
      var dio = Dio();
      var value = await dio.get(
          'https://update-nepucouseupdate-bmgwsddxxl.cn-hongkong.fcapp.run/update');
      String version = value.data[0]['version'];
      print(localVersion);
      if (version != Global.version && version != localVersion) {
        await Dialogs.materialDialog(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.black,
          msg: '要下载吗?',
          title: '有新版本啦,版本号是$version\n${value.data[0]['descrption']}',
          lottieBuilder: Lottie.asset(
            'assets/rockert-new.json',
            fit: BoxFit.contain,
          ),
          context: context,
          actions: [
            IconButton(
              onPressed: () {
                file.writeAsString(version);
                Navigator.pop(context);
              },
              icon: Icon(Icons.cancel_outlined),
            ),
            IconButton(
              onPressed: () async {
                file.writeAsString(version);
                Navigator.pop(context);
                if (Platform.isAndroid) {
                  ProgressDialog pd = ProgressDialog(context: context);
                  pd.show(
                      backgroundColor: Global.home_currentcolor,
                      max: 100,
                      msg: '准备下载更新...',
                      msgMaxLines: 5,
                      completed: Completed(
                        completedMsg: "下载完成!",
                        completedImage: AssetImage("assets/completed.gif"),
                        completionDelay: 2500,
                      ));
                  await EasyAppInstaller.instance.downloadAndInstallApk(
                    fileUrl: value.data[0]['link'],
                    fileDirectory: "updateApk",
                    fileName: "newApk.apk",
                    explainContent: "快去开启权限！！！",
                    onDownloadingListener: (progress) {
                      if (progress < 100) {
                        pd.update(value: progress.toInt(), msg: '安装包正在下载...');
                      } else {
                        pd.update(value: progress.toInt(), msg: '安装包下载完成...');
                      }
                    },
                    onCancelTagListener: (cancelTag) {
                      _cancelTag = cancelTag;
                    },
                  );
                } else {
                  Global().GlaunchUrl(Global.download_url);
                  Clipboard.setData(ClipboardData(text: Global.download_url));
                  AchievementView(
                      title: "复制成功",
                      subTitle: '请手动去浏览器粘贴网址，请手动下载对应您的平台',
                      icon: Icon(
                        Icons.insert_emoticon,
                        color: Colors.white,
                      ),
                      color: Colors.green,
                      duration: Duration(seconds: 15),
                      isCircle: true,
                      listener: (status) {
                        print(status);
                      })
                    ..show(context);
                }
              },
              icon: Icon(Icons.check),
            ),
          ],
        );
      }
    } else {
      await file.create();
      if (await file.exists()) {
        var dio = Dio();
        var value = await dio.get(
            'https://update-nepucouseupdate-bmgwsddxxl.cn-hongkong.fcapp.run/update');
        String version = value.data[0]['version'];
        if (version != Global.version) {
          await Dialogs.materialDialog(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
            msg: '要下载吗?',
            title: '有新版本啦,版本号是$version\n${value.data[0]['descrption']}',
            lottieBuilder: Lottie.asset(
              'assets/rockert-new.json',
              fit: BoxFit.contain,
            ),
            context: context,
            actions: [
              IconButton(
                onPressed: () {
                  file.writeAsString(version);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.cancel_outlined),
              ),
              IconButton(
                onPressed: () async {
                  if (Platform.isAndroid) {
                    ProgressDialog pd = ProgressDialog(context: context);
                    pd.show(
                        backgroundColor: Global.home_currentcolor,
                        max: 100,
                        msg: '准备下载更新...',
                        msgMaxLines: 5,
                        completed: Completed(
                          completedMsg: "下载完成!",
                          completedImage: AssetImage("assets/completed.gif"),
                          completionDelay: 2500,
                        ));
                    await EasyAppInstaller.instance.downloadAndInstallApk(
                      fileUrl: value.data[0]['link'],
                      fileDirectory: "updateApk",
                      fileName: "newApk.apk",
                      explainContent: "快去开启权限！！！",
                      onDownloadingListener: (progress) {
                        if (progress < 100) {
                          pd.update(value: progress.toInt(), msg: '安装包正在下载...');
                        } else {
                          pd.update(value: progress.toInt(), msg: '安装包下载完成...');
                        }
                      },
                      onCancelTagListener: (cancelTag) {
                        _cancelTag = cancelTag;
                      },
                    );
                  } else {
                    Global().GlaunchUrl(Global.download_url);
                    Clipboard.setData(ClipboardData(text: Global.download_url));
                    AchievementView(
                        title: "复制成功",
                        subTitle: '请手动去浏览器粘贴网址，密码是4huv，请手动下载对应您的平台',
                        icon: Icon(
                          Icons.insert_emoticon,
                          color: Colors.white,
                        ),
                        color: Colors.green,
                        duration: Duration(seconds: 15),
                        isCircle: true,
                        listener: (status) {
                          print(status);
                        })
                      ..show(context);
                  }
                },
                icon: Icon(Icons.check),
              ),
            ],
          );
        }
      }
    }
  }

  //更新课程
  Future<void> updateCourseFromJW(Dio dio, File file, BuildContext context,
      bool user1, File scoreFile, hItems) async {
    hItems(DateTime.now());
    if (Global.auto_update_course && !Global.isrefreshcourse) {
      if (user1)
        ApiService.noPerceptionLogin().then((value) async {
          Global.isrefreshcourse = true;
          late String logininfo;
          var url;
          logininfo = await Global().getLoginInfo();
          url =
              'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/course' +
                  logininfo;
          getApplicationDocumentsDirectory().then((value) async {
            //判断响应状态
            Response response = await dio.get(url);
            if (response.statusCode == 500) {
              showupdatenotice(
                  context,
                  3,
                  '与教务同步课程失败!',
                  '请检查你的密码或者教务系统是否正常',
                  Icon(
                    Icons.error,
                    color: Colors.white,
                  ),
                  Colors.red);
              return;
            } else if (response.statusCode == 200) {
              if (!response.data.toString().contains('fail')) {
                file.writeAsString(response.data);
                Global.isfirstread = true;
                jpushs().uploadpushid();

                updateScores(logininfo, user1, scoreFile, context);
                showupdatenotice(context, 3, '与教务同步课程成功!', '你的课程已经同步至最新',
                    Icon(Icons.check), Global.home_currentcolor);
              } else {
                showupdatenotice(
                    context,
                    3,
                    '与教务同步课程失败!',
                    '请检查你的密码或者教务系统是否正常',
                    Icon(
                      Icons.error,
                      color: Colors.white,
                    ),
                    Colors.red);

                return;
              }
            }
          });
        });
    }
  }

  //更新成绩
  void updateScores(String loginInfo, bool user1, File scoreFile, context) {
    Dio dio = new Dio();
    var urlscore =
        'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/getnewscore' +
            loginInfo +
            '&index=' +
            (user1
                ? Global.scoreinfos[Global.scoreinfos.length - 1]['cjdm']
                    .toString()
                : Global.scoreinfos2[Global.scoreinfos2.length - 1]['cjdm']
                    .toString());
    getApplicationDocumentsDirectory().then((value) async {
      try {
        Response response = await dio.get(urlscore);
        if (response.statusCode == 200) {
          //获取路径

          scoreFile.readAsString().then((value) {
            value = value.replaceAll(']', '') +
                ',' +
                response.data.toString().replaceAll('[', '');
            scoreFile.writeAsString(value);
            Global().getlist();
          });
          Dialogs.materialDialog(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
            msg: '去看看不?',
            title: '有新成绩啦!',
            lottieBuilder: Lottie.asset(
              'assets/rockert-new.json',
              fit: BoxFit.contain,
            ),
            context: context,
            actions: [
              IconButton(
                onPressed: () {
                  //关闭
                  Navigator.pop(context);
                },
                icon: Icon(Icons.cancel_outlined),
              ),
              IconButton(
                onPressed: () async {
                  //跳转到score页面
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => scorepage()));
                  Navigator.pop(context);
                },
                icon: Icon(Icons.check),
              ),
            ],
          );
        }
      } catch (e) {
        print('没有新的成绩');
      }
    });
  }

  void qinajia(context, loadqingjia) async {
    var dio = Dio();

    //下载评教
    getApplicationDocumentsDirectory().then((value) async {
      var urlqingjia =
          'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/getqingjia' +
              await Global().getLoginInfo();
      print(urlqingjia);
      //如果状态码为500，则弹窗提示
      var response = await dio.get(urlqingjia);
      if (response.statusCode == 500) {
        AchievementView(
            title: "hi!出错了，请点击左上角回到主页面，并且重新进来",
            subTitle: response.data.toString(),
            //onTab: _onTabAchievement,
            icon: Icon(
              Icons.emoji_emotions,
              color: Colors.white,
            ),
            color: Colors.green,
            duration: Duration(seconds: 3),
            isCircle: true,
            listener: (status) {
              print(status);
            })
          ..show(context);
      }
      getApplicationDocumentsDirectory().then((value) {
        File file = new File(value.path + '/qingjia.json');
        file.writeAsString(response.data.toString()).then((value) async {
          loadqingjia();
        });
      });
    });
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
      return Image.memory(response.data);
    } else {
      return Image.asset('assets/jwc_login.jpg');
    }
  }

  //无感知登录
  static Future<void> noPerceptionLogin() async {
    Dio dio = Dio();
    await dio
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
      await dio.get(
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

  //登录校验
  //使用Dio插件获取登录信息并返回登录信息
  Future<String> getLoginStatus(String username, String password,
      String verifyCode, setState, context) async {
    Dio dio = Dio();

    try {
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
    } catch (e) {
      return '网络错误';
    }
  }

  //提前激活chatgpt接口
  void active_chatgpt() {
    dio.get('https://chatgpt-chatgpt-lswirmtbkx.us-east-1.fcapp.run/');
  }

  Future<Response> sendToServer(List<Map<String, dynamic>> message) async {
    var headers = {'User-Agent': 'Apifox/1.0.0 (https://www.apifox.cn)'};
    //      messagess.add({'sender': '机器人', 'image': imageData});
    //提取出所有的message
    String messages = '';
    for (var item in message) {
      messages = messages + item['sender'] + ':' + item['message'] + '\n';
    }
    FormData formData = FormData.fromMap({
      'content': messages,
      'stuid': Global.jwc_xuehao,
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

  //发送语音到服务器
  Future<String> sendvoiceToServer(String path) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(path),
    });
    print('发送语音到服务器');
    try {
      Response response = await Dio().post(
        'https://chatgpt-chatgpt-lswirmtbkx.us-east-1.fcapp.run/voice',
        data: formData,
        options: Options(),
      );
      return response.data.toString();
    } catch (e) {
      throw e;
    }
  }

  Future<Response> sendlongtextToServer(String prompt, String content) async {
    var headers = {'User-Agent': 'Apifox/1.0.0 (https://www.apifox.cn)'};
    FormData formData = FormData.fromMap({
      'content': content,
      'prompt': prompt,
    });

    try {
      Response response = await Dio().post(
        'https://chatgpt-chatgpt-lswirmtbkx.us-east-1.fcapp.run/longtext',
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

  //广告
  Future<Response> getad() async {
    try {
      Response response = await Dio().get(
        'https://update-nepucouseupdate-bmgwsddxxl.cn-hongkong.fcapp.run/advertisement',
      );
      return response;
    } catch (e) {
      throw e;
    }
  }

  //生成图接口
  Future<Uint8List> recpicfromServer(String message, int type) async {
    FormData formData = FormData.fromMap({
      'content': message,
      'type': type,
      'xuehao': Global.jwc_xuehao,
    });
    Uint8List imageData;

    try {
      Response response = await Dio().post(
        'https://chatgpt-chatgpt-lswirmtbkx.us-east-1.fcapp.run/mermaid',
        data: formData,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );
      var responseData = response.data;

      imageData = Uint8List.fromList(responseData);
      return imageData;
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

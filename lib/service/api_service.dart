import 'dart:io';
import 'package:achievement_view/achievement_view.dart';
import 'package:dio/dio.dart';
import 'package:easy_app_installer/easy_app_installer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:muse_nepu_course/util/global.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sn_progress_dialog/options/completed.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../controller/LoginController.dart';
import '../page/ChatgptPage.dart';
import '../page/ScorePage.dart';
import '../util/jpushs.dart';

class ApiService {
  Dio dio = Dio();
  final LoginController loginController = Get.put(LoginController());
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

  void updateApp(context, _cancelTag) async {
    var directory = await getApplicationDocumentsDirectory();
    var path = directory.path;
    File file = File('$path/version.txt');

    String localVersion = await _getLocalVersion(file);
    var updateInfo = await _fetchUpdateInfo();

    if (updateInfo != null && updateInfo['version'] != Global.version && updateInfo['version'] != localVersion) {
      await _showUpdateDialog(context, file, updateInfo, _cancelTag);
    }
  }

  Future<String> _getLocalVersion(File file) async {
    if (await file.exists()) {
      return await file.readAsString();
    } else {
      await file.create();
      return '';
    }
  }

  Future<Map<String, dynamic>> _fetchUpdateInfo() async {
    var dio = Dio();
    var response = await dio.get('https://update-nepucouseupdate-bmgwsddxxl.cn-hongkong.fcapp.run/update');
    return response.data[0];
  }

  Future<void> _showUpdateDialog(BuildContext context, File file, Map<String, dynamic> updateInfo, _cancelTag) async {
    await Dialogs.materialDialog(
      color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
      msg: '要下载吗?',
      title: '有新版本啦,版本号是${updateInfo['version']}\n${updateInfo['descrption']}',
      lottieBuilder: Lottie.asset('assets/rockert-new.json', fit: BoxFit.contain),
      context: context,
      actions: [
        IconButton(
          onPressed: () {
            file.writeAsString(updateInfo['version']);
            Navigator.pop(context);
          },
          icon: Icon(Icons.cancel_outlined),
        ),
        IconButton(
          onPressed: () async {
            file.writeAsString(updateInfo['version']);
            Navigator.pop(context);
            await _handleUpdate(context, updateInfo, _cancelTag);
          },
          icon: Icon(Icons.check),
        ),
      ],
    );
  }

  Future<void> _handleUpdate(BuildContext context, Map<String, dynamic> updateInfo, _cancelTag) async {
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
        ),
      );
      await EasyAppInstaller.instance.downloadAndInstallApk(
        fileUrl: updateInfo['link'],
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
        icon: Icon(Icons.insert_emoticon, color: Colors.white),
        color: Colors.green,
        duration: Duration(seconds: 15),
        isCircle: true,
        listener: (status) {
          print(status);
        },
      )..show(context);
    }
  }
  //更新课程
  Future<void> updateCourseFromJW(Dio dio, File file, BuildContext context,
       File scoreFile, hItems) async {
    hItems(DateTime.now());
    if (Global.auto_update_course && !Global.isrefreshcourse) {

      Global.isrefreshcourse = true;
          late String logininfo;
          var url;
          logininfo = await loginController.getCookies();
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

                updateScores(logininfo, scoreFile, context);
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
    }
  }

  //更新成绩
  void updateScores(String loginInfo, File scoreFile, context) {
    Dio dio = new Dio();
    var urlscore =
        'https://nepu-backend-nepu-restart-sffsxhkzaj.cn-beijing.fcapp.run/getnewscore' +
            loginInfo +
            '&index=' +
             Global.scoreinfos[Global.scoreinfos.length - 1]['cjdm']
                    .toString();
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
              await loginController.getCookies();
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






  //提前激活chatgpt接口
  void active_chatgpt() {
    dio.get('https://chatgpt-chatgpt-lswirmtbkx.us-east-1.fcapp.run/');
  }

  Future<Response> sendToServer(List<Map<String, dynamic>> message) async {
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

}

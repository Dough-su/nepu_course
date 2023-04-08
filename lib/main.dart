import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:muse_nepu_course/jpushs.dart';
import 'package:muse_nepu_course/progress.dart';
import 'package:muse_nepu_course/easy_splash_screen.dart';
import 'package:lunar/lunar.dart';
import 'package:window_manager/window_manager.dart';
import 'chess/bloc/app_blocs.dart';
import 'global.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

Future<void> main() async {
  //判断是否是windows系统，如果是则启用windowmanager
  if (Platform.isWindows) {
    //windowmanager初始化
    WidgetsFlutterBinding.ensureInitialized();
    // 必须加上这一行。
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      backgroundColor: Colors.transparent, //背景色
      skipTaskbar: true, //是否在任务栏显示
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    //初始化开机自启
    WidgetsFlutterBinding.ensureInitialized();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    launchAtStartup.setup(
      appName: packageInfo.appName,
      appPath: Platform.resolvedExecutable,
    );
    await launchAtStartup.enable();
    Global.getdesktopinfo();
  }
  Global.getauto_update_course();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  runApp(SplashPage());
  doWhenWindowReady(() {
    const initialSize = Size(600, 700);
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  //获取今天的24节气
  ImageProvider<Object> jieqi() {
    var lunarYear = LunarYear.fromYear(DateTime.now().year);
    var jieQiJulianDays = lunarYear.getJieQiJulianDays();
    var date1 = DateTime.parse(DateTime.now().toString().substring(0, 10));
    print(date1);
    //定义一个Map，用于存放节气天数
    Map<String, String> map = {};
    for (var i = 0, j = jieQiJulianDays.length; i < j; i++) {
      var julianDay = jieQiJulianDays[i];
      var solar = Solar.fromJulianDay(julianDay);
      var lunar = solar.getLunar();
      //计算nowdate和节气的日期差值
      var date2 = DateTime.parse(solar.toString());
      var diff = date1.difference(date2).inDays;
      if (diff >= 0) {
        map[solar.toString()] = lunar.getJieQi();
      }
    }
    //获取最近的节气
    var min = map.values.toList()[map.length - 1];
    return AssetImage('assets/splash_screen/jieqi/' + min.toString() + '.jpg');
  }

  void initState() {
    super.initState();
    createAppBlocs();
    Global().getusername();
    Global().loadItems(DateTime.now());
    jpushs().addlistenerandinit(); //推送通知
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EasySplashScreen(
        logo: Image.asset(
          'images/logo.png',
        ),
        title: Text(
          textAlign: TextAlign.right,
          strutStyle: StrutStyle(
            forceStrutHeight: true,
            height: 1.5,
            leading: 0.5,
          ),
          "",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundImage: //ImageProvider<Object>?
            jieqi(),
        backgroundColor: Colors.white,
        showLoader: true,
        loadingText: Text("正在加载...", style: TextStyle(color: Colors.white)),
        navigator: WithBuilder(),
        durationInSeconds: 3,
        loaderColor: Colors.white,
      ),
    );
  }
}

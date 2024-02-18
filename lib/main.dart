import 'dart:io';

import 'package:flutter/material.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:muse_nepu_course/page/earth.dart';
import 'package:muse_nepu_course/util/jpushs.dart';
import 'package:muse_nepu_course/theme/color_schemes.g.dart';
import 'package:window_manager/window_manager.dart';
import 'util/global.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

Future<void> main() async {
  if (Platform.isWindows||Platform.isMacOS) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
    });
    WidgetsFlutterBinding.ensureInitialized();
    launchAtStartup.setup(
      appName: '东油课表',
      appPath: Platform.resolvedExecutable,
    );
    await launchAtStartup.enable();
    Global.getdesktopinfo();
  }
  Global.getauto_update_course();
  WidgetsFlutterBinding.ensureInitialized();
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
  void initState() {
    super.initState();
    Global().loadItems(DateTime.now());
    //只有安卓才会初始化极光推送
    if(Platform.isAndroid)
    jpushs().addlistenerandinit();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: SplashScreen(),
    );
  }
}

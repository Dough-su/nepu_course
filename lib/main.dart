import 'dart:io';

import 'package:flutter/material.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:muse_nepu_course/jpushs.dart';
import 'package:muse_nepu_course/progress.dart';
import 'package:muse_nepu_course/easy_splash_screen.dart';
import 'package:muse_nepu_course/theme/color_schemes.g.dart';
import 'package:muse_nepu_course/widget/image_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'global.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

Future<void> main() async {
  if (Platform.isWindows) {
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
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    launchAtStartup.setup(
      appName: packageInfo.appName,
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
    Global.getusername2();
    Global().loadItems(DateTime.now());
    Global().loadItems2(DateTime.now());
    jpushs().addlistenerandinit();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: EasySplashScreen(
        logo: Image.asset('images/logo.png'),
        title: Text(
          '',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundImage: image_provider().jieqi(),
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

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:muse_nepu_course/jpushs.dart';
import 'package:muse_nepu_course/progress.dart';
import 'package:muse_nepu_course/easy_splash_screen.dart';
import 'package:lunar/lunar.dart';
import 'Todo/models/task.dart';
import 'global.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

Future<void> main() async {
  /// Initial Hive DB
  await Hive.initFlutter();

  /// Register Hive Adapter
  Hive.registerAdapter<Task>(TaskAdapter());

  /// Open box
  var box = await Hive.openBox<Task>("tasksBox");

  /// Delete data from previous day
  // ignore: avoid_function_literals_in_foreach_calls
  box.values.forEach((task) {
    if (task.createdAtTime.day != DateTime.now().day) {
      task.delete();
    } else {}
  });
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  runApp(SplashPage());
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

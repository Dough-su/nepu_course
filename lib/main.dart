import 'package:flutter/material.dart';
import 'package:muse_nepu_course/home.dart';
import 'package:muse_nepu_course/progress.dart';
import 'package:muse_nepu_course/easy_splash_screen.dart';
import 'package:lunar/lunar.dart';
import 'global.dart';

void main() {
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

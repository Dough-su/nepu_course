import 'package:flutter/material.dart';
import 'package:lunar/calendar/LunarYear.dart';
import 'package:lunar/calendar/Solar.dart';
import 'package:muse_nepu_course/global.dart';
import 'package:muse_nepu_course/service/io_service.dart';

class image_provider {
  Widget getcalanderlogopngx() {
    io_service().calanderlogo();
    //返回组件的ImageProvider<Object>类型
    return Container(
      child: Image(
        image: Global().calendarlogo,
      ),
    );
  }

  ImageProvider<Object> getlogopngx() {
    io_service().getlogopng();
    return Global().logopic;
  }

  ImageProvider<Object> jieqi() {
    var lunarYear = LunarYear.fromYear(DateTime.now().year);
    var jieQiJulianDays = lunarYear.getJieQiJulianDays();
    var date1 = DateTime.parse(DateTime.now().toString().substring(0, 10));
    Map<String, String> map = {};
    for (var i = 0, j = jieQiJulianDays.length; i < j; i++) {
      var julianDay = jieQiJulianDays[i];
      var solar = Solar.fromJulianDay(julianDay);
      var lunar = solar.getLunar();
      var date2 = DateTime.parse(solar.toString());
      var diff = date1.difference(date2).inDays;
      if (diff >= 0) {
        map[solar.toString()] = lunar.getJieQi();
      }
    }
    var min = map.values.toList()[map.length - 1];
    return AssetImage('assets/splash_screen/jieqi/' + min.toString() + '.jpg');
  }
}

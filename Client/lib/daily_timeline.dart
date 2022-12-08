import 'package:dynamic_timeline/dynamic_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'event.dart';

class DailyTimeline extends StatefulWidget {
  const DailyTimeline({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _DailyTimelineState();
  }

  static GlobalKey<_DailyTimelineState> daily =
      GlobalKey<_DailyTimelineState>();

  // void refresh() {
  //   //调用_DailyTimelineState中的refresh方法
  //   daily.currentIntance()?.refresh();
  // }
}

class _DailyTimelineState extends State<DailyTimeline> {
  final title = '今日课程';

  @override
  Widget build(BuildContext context) {
    final items = [
      TimelineItem(
        startDateTime: DateTime(1970, 1, 1, 8, 30),
        endDateTime: DateTime(1970, 1, 1, 9, 55),
        child: const Event(title: '课程1'),
      ),
      TimelineItem(
        startDateTime: DateTime(1970, 1, 1, 10),
        endDateTime: DateTime(1970, 1, 1, 11, 30),
        child: const Event(title: '课程2'),
      ),
      TimelineItem(
        startDateTime: DateTime(1971, 1, 1, 15),
        endDateTime: DateTime(1971, 1, 1, 17),
        child: const Event(title: '课程3'),
      ),
    ];
    List<TimelineItem> loadItems() {
      items.add(TimelineItem(
        startDateTime: DateTime(1970, 1, 1, 12, 30),
        endDateTime: DateTime(1970, 1, 1, 15, 55),
        child: const Event(title: '课程' + '1'),
      ));
      return items;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('本周课程'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: DynamicTimeline(
              firstDateTime: DateTime(1970, 1, 1, 8, 30),
              lastDateTime: DateTime(1970, 1, 1, 22),
              labelBuilder: DateFormat('HH:mm').format,
              intervalDuration: const Duration(hours: 1),
              maxCrossAxisItemExtent: 200,
              intervalExtent: 80,
              minItemDuration: const Duration(minutes: 30),
              items: loadItems()),
        ),
      ),
    );
  }
}

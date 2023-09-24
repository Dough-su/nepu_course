import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:path_provider/path_provider.dart';
import '../util/global.dart';

///Class to hold data for itembuilder in Withbuilder app.
class ItemData {
  final Color color;
  final String image;
  final String text1;
  final String text2;
  final String text3;

  ItemData(this.color, this.image, this.text1, this.text2, this.text3);
}

/// Example of LiquidSwipe with itemBuilder
class WithBuilder extends StatefulWidget {
  @override
  _WithBuilder createState() => _WithBuilder();
}

class _WithBuilder extends State<WithBuilder> {
  int page = 0;
  late LiquidController liquidController;
  late UpdateType updateType;

  List<ItemData> data = [
    ItemData(Colors.blue, "assets/jwc_login.jpg", "Hi", "欢迎来到", "东油课表"),
    ItemData(Colors.deepPurpleAccent, "assets/jwc_login.jpg", "它能做什么？", "让我们",
        "一探究竟"),
    ItemData(Colors.green, "assets/course.png", "例如?", "无网络!", "查看课表"),
    ItemData(Colors.yellow, "assets/score.png", "也可以", "随时随地", "查看带有排名的成绩"),
    ItemData(Colors.red, "assets/pingjiao.png", "还有", "省去评教时间的", "一键评教!"),
    ItemData(
        Colors.purple, "assets/chaoxing.png", "甚至", "查看学习通未发布的成绩", "令人期待吧!"),
    ItemData(Colors.pink, "assets/jwc_login.jpg", "欢迎", "与我", "一起探索!"),
  ];

  void initState() {
    liquidController = LiquidController();
    getApplicationDocumentsDirectory().then((value) {
      //判断是否有fist.txt文件,没有则创建，有则调用isfirst方法
      File file = new File(value.path + '/first.txt');
      file.exists().then((value) {
        if (!value) {
          file.create();
        }
      });
    });
    super.initState();
  }

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((page ?? 0) - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selectedness;
    return new Container(
      width: 25.0,
      child: new Center(
        child: new Material(
          color: Colors.white,
          type: MaterialType.circle,
          child: new Container(
            width: 8.0 * zoom,
            height: 8.0 * zoom,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          LiquidSwipe.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                color: data[index].color,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset(
                      data[index].image,
                      height: 400,
                      fit: BoxFit.contain,
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          data[index].text1,
                          style: WithPages.style,
                        ),
                        Text(
                          data[index].text2,
                          style: WithPages.style,
                        ),
                        Text(
                          data[index].text3,
                          style: WithPages.style,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            positionSlideIcon: 0.8,
            slideIconWidget: Icon(Icons.arrow_back_ios),
            onPageChangeCallback: pageChangeCallback,
            waveType: WaveType.liquidReveal,
            liquidController: liquidController,
            fullTransitionValue: 880,
            enableSideReveal: true,
            enableLoop: true,
            ignoreUserGestureWhileAnimating: true,
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(data.length, _buildDot),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextButton(
                onPressed: () {
                  liquidController.animateToPage(
                      page: data.length - 1, duration: 700);
                },
                child: Text("进入课表"),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextButton(
                onPressed: () {
                  liquidController.jumpToPage(
                      page: liquidController.currentPage + 1 > data.length - 1
                          ? 0
                          : liquidController.currentPage + 1);
                },
                child: Text("下一个"),
              ),
            ),
          )
        ],
      ),
    );
  }

  pageChangeCallback(int lpage) async {
    setState(() {
      page = lpage;
    });
    print("第 $page");
    //如果最后一页，则调用isFirst()方法
    if (lpage == data.length - 1) {
      Global().isFirst(context);
    }
  }
}

///Example of App with LiquidSwipe by providing list of widgets
class WithPages extends StatefulWidget {
  static final style = TextStyle(
    fontSize: 30,
    fontFamily: "Billy",
    fontWeight: FontWeight.w600,
  );

  @override
  _WithPages createState() => _WithPages();
}

class _WithPages extends State<WithPages> {
  int page = 0;
  late LiquidController liquidController;
  late UpdateType updateType;

  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  final pages = [Container()];

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((page ?? 0) - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selectedness;
    return new Container(
      width: 25.0,
      child: new Center(
        child: new Material(
          color: Colors.white,
          type: MaterialType.circle,
          child: new Container(
            width: 8.0 * zoom,
            height: 8.0 * zoom,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          LiquidSwipe(
            pages: pages,
            slideIconWidget: Icon(Icons.arrow_back_ios),
            onPageChangeCallback: pageChangeCallback,
            waveType: WaveType.liquidReveal,
            liquidController: liquidController,
            enableSideReveal: true,
            ignoreUserGestureWhileAnimating: true,
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(pages.length, _buildDot),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextButton(
                onPressed: () {
                  liquidController.animateToPage(
                      page: pages.length - 1, duration: 700);
                },
                child: Text("跳过引导"),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextButton(
                onPressed: () {
                  liquidController.jumpToPage(
                      page: liquidController.currentPage + 1 > pages.length - 1
                          ? 0
                          : liquidController.currentPage + 1);
                },
                child: Text("下一页"),
              ),
            ),
          )
        ],
      ),
    );
  }

  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
  }
}

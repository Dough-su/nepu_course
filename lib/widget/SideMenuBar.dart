import 'dart:io';

import 'package:achievement_view/achievement_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rive/rive.dart';

import 'package:shrink_sidemenu/shrink_sidemenu.dart';

import '../chaoxing/chaoxing.dart';
import '../chatforgpt/chatgpt2.dart';
import '../coursemenu/about.dart';
import '../coursemenu/scoredetail.dart';
import '../global.dart';
import '../login/chaoxinglogin.dart';
import '../pingjiao/pingjiao.dart';
import '../qingjia/qingjia.dart';
import '../service/io_service.dart';
class SideMenuBar{
  //侧边
 static Widget side(bool isfront,context, _sideMenuKey, _sideMenuKey2,changeColor,shijian,setState,toggleMenu,isOpened,scoredetailbtn,scoredetailbtn2,hItems,_controller,_calendarAgendaControllerAppBar,home_body,title,isdownload) {
    return SideMenu(
        background: Global.home_currentcolor,
        key: isfront ? _sideMenuKey : _sideMenuKey2,
        menu: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 1.6,
                  child: RiveAnimation.asset(
                    'assets/cat.riv',
                    //缩小
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16.0),
                          Text(
                            shijian(),
                            style: TextStyle(color: Colors.white),
                          ),

                          SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.cached,
                          size: 20.0, color: Colors.white),
                      title: Text(
                        '查看成绩',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => scorepage(),
                        ),
                      ),
                    ),
                    ListTile(
                        leading: const Icon(Icons.score_outlined,
                            size: 20.0, color: Colors.white),
                        title: Text(
                          'chatgpt',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatPage()));
                        }),
                    ListTile(
                      leading: const Icon(Icons.book_online,
                          size: 20.0, color: Colors.white),
                      title: Text(
                        '一键评教',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => pingjiao()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.book_online,
                          size: 20.0, color: Colors.white),
                      title: Text(
                        '请假历史',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => qingjia()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.colorize,
                          size: 20.0, color: Colors.white),
                      title: Text(
                        '调个色',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('选择当前页颜色'),
                                content: SingleChildScrollView(
                                  child: ColorPicker(
                                    pickerColor: Global.home_currentcolor,
                                    onColorChanged: changeColor,
                                    colorPickerWidth: 300.0,
                                    pickerAreaHeightPercent: 0.7,
                                    enableAlpha: false,
                                    displayThumbColor: true,
                                    showLabel: true,
                                    paletteType: PaletteType.hsv,
                                    pickerAreaBorderRadius:
                                    const BorderRadius.only(
                                      topLeft: const Radius.circular(2.0),
                                      topRight: const Radius.circular(2.0),
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('确定'),
                                    onPressed: () async {
                                      setState(() => Global.home_currentcolor =
                                          Global.home_pickcolor);
                                      getApplicationDocumentsDirectory()
                                          .then((value) {
                                        File file =
                                        File(value.path + '/color.txt');
                                        //判断文件是否存在
                                        if (file.existsSync()) {
                                          //存在则写入
                                          file.writeAsString(Global
                                              .home_currentcolor.value
                                              .toString());
                                        } else {
                                          //不存在则创建文件并写入
                                          file.createSync();
                                          file.writeAsString(Global
                                              .home_currentcolor.value
                                              .toString());
                                        }
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                    ListTile(
                        leading: const Icon(Icons.score_outlined,
                            size: 20.0, color: Colors.white),
                        title: Text(
                          '查看学习通考试成绩',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          getApplicationDocumentsDirectory()
                              .then((value) async {
                            //读取chaoxing.txt
                            var file =
                            await new File(value.path + "/chaoxing.txt");
                            //如果文件存在，就跳转到成绩页面
                            if (file.existsSync()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => chaoxing()),
                              );
                            } else {
                              //如果文件不存在，就跳转到登录页面
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => chaoxinglogin()),
                              );
                            }
                          });
                        }),
                    ListTile(
                      leading: const Icon(Icons.cached,
                          size: 20.0, color: Colors.white),
                      title: Text(
                        '重新登入',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        io_service().deleteFiles();
                        AchievementView(context,
                            title: "成功!",
                            subTitle: "已清除课程和成绩缓存，请退出app重新登录",
                            //onTab: _onTabAchievement,
                            icon: Icon(
                              Icons.insert_emoticon,
                              color: Colors.white,
                            ),
                            //typeAnimationContent: AnimationTypeAchievement.fadeSlideToUp,
                            //borderRadius: 5.0,
                            color: Colors.green,
                            //textStyleTitle: TextStyle(),
                            //textStyleSubTitle: TextStyle(),
                            //alignment: Alignment.topCenter,
                            duration: Duration(seconds: 3),
                            isCircle: true, listener: (status) {
                              print(status);
                            })
                          ..show();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings,
                          size: 20.0, color: Colors.white),
                      title: Text(
                        '关于&设置',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => about()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            )),
        type: SideMenuType.slideNRotate,
        onChange: (_isOpened) {
          if (isOpened) {
            Global.bottombarheight = 60;
          } else {
            Global.bottombarheight = 0;
          }
          setState(() => isOpened = _isOpened);
        },
        child: IgnorePointer(
            ignoring: isOpened,
            child: Scaffold(
              appBar: AppBar(
                  backgroundColor: Global.home_currentcolor,
                  title: Text(title),
                  centerTitle: true,
                  leading: isfront
                      ? IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      toggleMenu();
                    },
                  )
                      : Container(),
                  actions: [
                    IconButton(
                      key: isfront ? scoredetailbtn : scoredetailbtn2,
                      icon: Icon(Icons.score),
                      onPressed: () {
                        if (isdownload) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => scorepage()),
                          );
                        } else {
                          AchievementView(context,
                              title: "出错啦!",
                              subTitle: '请确认现在是否学校在抢课或其他原因导致成绩下载超时',
                              //onTab: _onTabAchievement,
                              icon: Icon(
                                Icons.error,
                                color: Colors.white,
                              ),
                              color: Colors.red,
                              duration: Duration(seconds: 3),
                              isCircle: true, listener: (status) {
                                print(status);
                              })
                            ..show();
                        }
                      },
                    ),
                  ]),
              body: home_body(isfront),
              floatingActionButton: Stack(children: [
                MaterialButton(
                  onPressed: () {
                    _controller = SimpleAnimation('起飞');
                    Future.delayed(Duration(seconds: 2), () {
                      _controller = SimpleAnimation('保持飞翔');
                      _controller = SimpleAnimation('降落');
                      Future.delayed(Duration(seconds: 2), () {
                        _controller = SimpleAnimation('行走');
                      });
                    });
                    hItems(DateTime.now(), false);
                    setState(() {
                      print('回到今天');
                      _calendarAgendaControllerAppBar.goToDay(DateTime.now());
                    });
                  },
                  child: Text(
                    '回到今天',
                  ),
                  shape: StadiumBorder(),
                  textColor: Colors.white,
                  color: Global.home_currentcolor,
                ),
                GestureDetector(
                  onTap: () {
                    _controller = SimpleAnimation('起飞');
                    Future.delayed(Duration(seconds: 2), () {
                      _controller = SimpleAnimation('保持飞翔');
                      _controller = SimpleAnimation('降落');
                      Future.delayed(Duration(seconds: 2), () {
                        _controller = SimpleAnimation('行走');
                      });
                    });
                    setState(() {
                      print('回到今天');
                      _calendarAgendaControllerAppBar.goToDay(DateTime.now());
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.17,
                    height: MediaQuery.of(context).size.width * 0.17,
                    child: RiveAnimation.asset(
                      'assets/birds.riv',
                      controllers: [_controller],
                      animations: ['行走', '起飞', '保持飞翔', '降落'],
                    ),
                  ),
                ),
              ]),
            )));
  }

}
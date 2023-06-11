import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:achievement_view/achievement_view.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:muse_nepu_course/global.dart';
import 'package:muse_nepu_course/home.dart';
import 'package:muse_nepu_course/service/api_service.dart';
import 'package:muse_nepu_course/theme/color_schemes.g.dart';
import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:file_picker/file_picker.dart';
import 'package:muse_nepu_course/widget/CustomDialog.dart';
import 'package:muse_nepu_course/widget/DocxDialog.dart';
import 'package:muse_nepu_course/widget/MyDialog.dart';
import 'package:path_provider/path_provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

var _filteredStringList = [];
var _stringList = [];
int _selectedIndex = -1;
String? _selectedValue;
bool sending = false;

//从assets/prompts.json中读取数据,并转换为List<Map<String, String>>
void loadprompts() async {
  String prompt = await rootBundle.loadString('assets/prompts.json');
  _stringList = json.decode(prompt);
  _filteredStringList = List.from(_stringList);
}

final TextEditingController _textEditingController = TextEditingController();
final BottomBarWithSheetController _bottomBarController =
    BottomBarWithSheetController(initialIndex: 0);
final List<Map<String, dynamic>> messagess = [];
bool showAnimation = true;

class _ChatPageState extends State<ChatPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final _bottomBarController = BottomBarWithSheetController(initialIndex: 0);
  final _selectedTags = <String>[];
  final _unselectedTags = <String>[
    // '#写一个论文并发回(暂不可用)',
    '#翻译docx',
    '#对docx自定义操作',
    '#对长文章自定义操作',
    '#翻译长文章',
    // '#生成图片',
    '#总结docx内容',
    '#(难逃法眼)检测文章是否由chatgpt完成',
    '#生成流程图',
    '#生成关系图',
    '#生成ER图',
    '#生成实体关系图',
    '#生成网络拓扑图',
    '#生成UML图',
    '#生成时序图',
    '#生成甘特图',
    '#生成韦恩图',
    '#生成树状图',
    '#生成饼图',
    '#生成用例图',
    '#生成思维导图',
  ];
  Future<void> generate(e) async {
    print(e);
    if (e.contains('docx')) {
      print('docx');
      _bottomBarController.closeSheet();

      showDialog(
        context: context,
        builder: (context) => DocxDialog(
          onUploadSuccess: (Map<String, dynamic> status) {
            // 处理状态信息
            if (status['status'] == 'success') {
              print(status['message']);
              //关闭对话框
              Navigator.of(context).pop();
            } else {
              print('文件上传失败');
            }
          },
          externalSetState: (VoidCallback fn) {
            setState(fn);
          },
        ),
      );
    }
    //如果e包含流程图则type为1,关系图为2,ER图为3,实体关系图为4,网络拓扑图为5,UML图为6,时序图为7,甘特图为8,韦恩图为9,树状图为10,饼图为11
    if (e.contains('#生成')) {
      e = e.replaceAll('#生成', '');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: '提示',
            hintText: '请输入参数',
            controller: _textEditingController,
            onConfirm: (String value) async {
              addLoadingToMessages();
              int type = 1;
              // 在这里执行相关操作，例如生成图片
              print('生成图片，参数为：$value');
              _bottomBarController.closeSheet();

              switch (e) {
                case '流程图':
                  type = 1;
                  break;
                case '关系图':
                  type = 2;
                  break;
                case 'ER图':
                  type = 3;
                  break;
                case '实体关系图':
                  type = 4;
                  break;
                case '网络拓扑图':
                  type = 5;
                  break;
                case 'UML图':
                  type = 6;
                  break;
                case '时序图':
                  type = 7;
                  break;
                case '甘特图':
                  type = 8;
                  break;
                case '韦恩图':
                  type = 9;
                  break;
                case '树状图':
                  type = 10;
                  break;
                case '饼图':
                  type = 11;
                  break;
                case '用例图':
                  type = 12;
                  break;
                case '思维导图':
                  type = 13;
                  break;
                default:
                  type = 1;
                  break;
              }
              try {
                Uint8List response = await ApiService()
                    .recpicfromServer(_textEditingController.text, type);
                Uint8List imageData = response;
                //移除loading
                messagess.removeLast();
                addImageToMessages(imageData); // 添加图片到消息列表中
              } catch (e) {
                print('图片获取失败: $e');
              }
            },
          );
        },
      );
    }
    if (e.contains('长')) {
      String text1 = '';
      String text2 = '';

      if (e == '#对长对话自定义操作') {
        text1 = '请输入想做的操作';
        text2 = '请输入长对话';
      }
      if (e == '#翻译长文章') {
        text1 = '请输入你的翻译需求';
        text2 = '请输入文章';
      }

      final result = await showDialog(
        context: context,
        builder: (context) => MyDialog(hint1: text1, hint2: text2),
      );
      _bottomBarController.closeSheet();

      if (result != null) {
        // 用户点击了“确定”按钮，并且输入了文本。
        final text1 = result['text1'];
        final text2 = result['text2'];
        try {
          Response response =
              await ApiService().sendlongtextToServer(text1, text2);
          Timer timer;
          bool isTimeout = false;
          //500毫秒执行一次
          timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
            if (isTimeout) {
              timer.cancel();
              print('取消定时器');
              Global.messages_pure += " AI: " + xdata.toString() + ";";
              setState(() {});
              xdata = '';
              setState(() {
                sending = false;
              });
              controller.reset();
              return;
            }
            setState(() {});
          });
          response.data.stream.listen((value) {
            if (xdata != '') messagess.removeLast();

            xdata += utf8.decode(value);
            xdata = xdata
                .replaceAll('AI:', '')
                .replaceAll('AI：', '')
                .replaceAll('机器人:', '')
                .replaceAll('机器人：', '')
                .replaceAll('Bot:', '')
                .replaceAll('Bot：', '');
            messagess.add({'sender': 'GPT', 'message': xdata});
            setState(() {
              if (_isAtBottom) {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
                });
              }
              showAnimation = false; // 当有消息时，停止显示动画
            });
          }, onDone: () {
            print('数据接收完毕');
            isTimeout = true;
          });
        } catch (e) {
          print(e);
        }
      } else {
        // 用户点击了“取消”按钮。
        print('用户取消了输入。');
      }
    }
  }

  void addImageToMessages(Uint8List imageData) {
    setState(() {
      messagess.add({'sender': '机器人', 'image': imageData});
      _textEditingController.clear();
    });
  }

  void _onConfirm(File file, String operation) {
    // 在这里处理文件和文本框的值
  }
  void addLoadingToMessages() {
    setState(() {
      messagess.add({'sender': '机器人', 'loading': true});
    });
  }

  String xdata = '';
  late AnimationController controller;

  bool _isAtBottom = true;

  int _maxLines = 1; // 最多显示的行数

  @override
  void initState() {
    super.initState();
    Global.bottombarheight = 60;
    messagess.clear();
    Global.messages_pure = '';
    ApiService().active_chatgpt();
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _focusNode.requestFocus();

    loadprompts(); // 加载提示语句

    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (_isAtBottom) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }

  Future<void> saveImageToGallery(Uint8List imageBytes) async {
    if (Platform.isAndroid || Platform.isIOS) {
      final result = await ImageGallerySaver.saveImage(imageBytes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('已保存到相册'),
          duration: Duration(seconds: 1),
        ),
      );
    } else if (Platform.isWindows || Platform.isMacOS) {
      final file = saveUint8ListToDesktop(imageBytes);
      showupdatenotice(
          context, 2, '图片已保存到桌面', '成功', Icon(Icons.check), Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Global.home_currentcolor,
            title: Text(
              '双击消息复制,长按保存图片',
              maxLines: 3,
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (context) => HomePage()));
                //回到上一级
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Scaffold(
                            appBar: AppBar(
                              backgroundColor: Global.home_currentcolor,
                              title: Text('自动注入消息'),
                            ),
                            body: ListView.builder(
                              itemCount: _filteredStringList.length,
                              itemBuilder: (BuildContext context, int index) {
                                String act = _filteredStringList[index]["act"]!;
                                String prompt =
                                    _filteredStringList[index]["prompt"]!;
                                return RadioListTile(
                                  title: Text("行为: $act"),
                                  subtitle: Text("语句: $prompt"),
                                  value: index,
                                  groupValue: _selectedIndex,
                                  onChanged: (int? value) {
                                    setState(() {
                                      _selectedIndex = value!;
                                      _selectedValue =
                                          _filteredStringList[_selectedIndex]
                                              ["act"];
                                      //发送消息

                                      _controller.text =
                                          _filteredStringList[_selectedIndex]
                                              ["prompt"];
                                      //返回主页面
                                      Navigator.pop(context);
                                    });
                                  },
                                );
                              },
                            ));
                      });
                },
              ),
            ],
          ),
          body: Container(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    child: messagess.isEmpty
                        ? FadeInUp(
                            child: AnimatedOpacity(
                            opacity: showAnimation ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 500),
                            child: Center(
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                child: AnimatedTextKit(
                                  animatedTexts: [
                                    ColorizeAnimatedText(
                                      'chatgpt',
                                      colors: [
                                        Colors.purple,
                                        Colors.blue,
                                        Colors.yellow,
                                        Colors.red,
                                      ],
                                      textStyle: TextStyle(fontSize: 50.0),
                                    ),
                                  ],
                                  isRepeatingAnimation: true,
                                ),
                              ),
                            ),
                          ))
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: messagess.length,
                            itemBuilder: (BuildContext context, int index) {
                              String? sender = messagess[index]['sender'];
                              String? message = messagess[index]['message'];
                              Uint8List? image = messagess[index]['image'];
                              bool? loading = messagess[index]['loading'];
                              print(image);
                              if (loading != null && loading) {
                                return FadeInUp(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        //一个圆形的进度条
                                        CircularProgressIndicator(),
                                      ],
                                    ),
                                  ),
                                );
                              } else if (image != null) {
                                return FadeInUp(
                                  child: GestureDetector(
                                    onLongPress: () async {
                                      // 长按保存图片
                                      await saveImageToGallery(image);
                                    },
                                    child: Image.memory(image),
                                  ),
                                );
                              } else {
                                return FadeInUp(
                                    child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                  child: GestureDetector(
                                    onDoubleTap: () {
                                      Clipboard.setData(
                                          ClipboardData(text: message));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('已复制到剪贴板'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment: sender == '我'
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (sender != '我') SizedBox(width: 8.0),
                                        Flexible(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
                                            decoration: BoxDecoration(
                                              color: sender == '我'
                                                  ? Global.home_currentcolor
                                                  : Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? Colors.grey[200]
                                                      : Colors.grey[800],
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            child: MarkdownBody(
                                              data: message!,
                                            ),
                                          ),
                                        ),
                                        if (sender == '我') SizedBox(width: 8.0),
                                      ],
                                    ),
                                  ),
                                ));
                              }
                            },
                          ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete_sweep_outlined),
                            color: Global.home_currentcolor,
                            onPressed: () {
                              setState(() {
                                showAnimation = true;
                                messagess.clear();
                                Global.messages_pure = '';
                              });
                            },
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: TextField(
                                focusNode: _focusNode,
                                controller: _controller,
                                onChanged: (value) {
                                  final lines = value.split('\n').length;
                                  setState(() {
                                    _maxLines = lines + 1;
                                  });
                                },
                                maxLines: _maxLines,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          AnimatedBuilder(
                            // 包裹IconButton的AnimatedBuilder，用于构建进度指示器
                            animation: controller,
                            builder: (BuildContext context, Widget? child) {
                              return IconButton(
                                icon: sending
                                    ? SizedBox(
                                        width: 24.0,
                                        height: 24.0,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Global.home_currentcolor),
                                        ),
                                      )
                                    : Icon(Icons.send),
                                color: Global.home_currentcolor,
                                onPressed: () async {
                                  sendmessage();
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      BottomBarWithSheet(
                        mainActionButtonTheme: MainActionButtonTheme(
                          color: Global.home_currentcolor,
                          icon: Icon(Icons.extension_rounded),
                        ),
                        controller: _bottomBarController,
                        autoClose: true,
                        sheetChild: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Wrap(
                                spacing: 10,
                                children: _unselectedTags
                                    .map((e) => ActionChip(
                                          // shadowColor: Global.home_currentcolor,
                                          surfaceTintColor:
                                              Global.home_currentcolor,
                                          // backgroundColor:
                                          //     Global.home_currentcolor,
                                          label: Text(e),
                                          onPressed: () {
                                            generate(e);
                                          },
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                        items: const [],
                      ),
                    ])),
              ],
            ),
          ),
        ));
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  Future<void> sendmessage() async {
    String message = _controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      sending = true;
    });
    controller.repeat();

    _controller.clear();

    setState(() {
      _controller.clear();
      messagess.add({'sender': '我', 'message': message});
      Global.messages_pure += " Me: " + message + ";";
    });
    if (_isAtBottom) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }

    try {
      Response response = await ApiService().sendToServer(message);
      Timer timer;
      bool isTimeout = false;
      //500毫秒执行一次
      timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
        if (isTimeout) {
          timer.cancel();
          print('取消定时器');
          Global.messages_pure += " AI: " + xdata.toString() + ";";
          setState(() {});
          xdata = '';
          setState(() {
            sending = false;
          });
          controller.reset();
          return;
        }
        setState(() {});
      });
      response.data.stream.listen((value) {
        if (xdata != '') messagess.removeLast();

        xdata += utf8.decode(value);
        xdata = xdata
            .replaceAll('AI:', '')
            .replaceAll('AI：', '')
            .replaceAll('机器人:', '')
            .replaceAll('机器人：', '')
            .replaceAll('Bot:', '')
            .replaceAll('Bot：', '');
        messagess.add({'sender': 'GPT', 'message': xdata});
        setState(() {
          if (_isAtBottom) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent);
            });
          }
          showAnimation = false; // 当有消息时，停止显示动画
        });
      }, onDone: () {
        print('数据接收完毕');
        isTimeout = true;
      });
    } catch (e) {
      print(e);
    }
  }
}

Future<File> saveUint8ListToDesktop(Uint8List bytes) async {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final fileName = 'file_$timestamp.png';
  final documentsDir = await getApplicationDocumentsDirectory();
  final desktopDir = Directory('${documentsDir.parent.path}/Desktop');
  final filePath = '${desktopDir.path}/$fileName';
  final file = File(filePath);
  await file.writeAsBytes(bytes);
  return file;
}

void showupdatenotice(BuildContext context, int second, String title,
    String subtitle, Icon icon, Color color) {
  AchievementView(context,
      title: title,
      subTitle: subtitle,
      icon: icon,
      color: color,
      duration: Duration(seconds: second),
      isCircle: true,
      listener: (status) {})
    ..show();
}

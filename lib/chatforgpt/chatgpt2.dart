import 'dart:async';
import 'dart:convert';

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

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

var _filteredStringList = [];
var _stringList = [];
int _selectedIndex = -1;
String? _selectedValue;

//从assets/prompts.json中读取数据,并转换为List<Map<String, String>>
void loadprompts() async {
  String prompt = await rootBundle.loadString('assets/prompts.json');
  _stringList = json.decode(prompt);
  _filteredStringList = List.from(_stringList);
}

class _ChatPageState extends State<ChatPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final _bottomBarController = BottomBarWithSheetController(initialIndex: 0);
  final _selectedTags = <String>[];
  final _unselectedTags = <String>[
    '#写一个论文并以docx发回',
    '#翻译dcox',
    '#对dcox自定义操作',
    '#对长对话自定义操作',
    '#翻译长文章',
    '#生成图片',
    '#生成思维导图',
    '#总结docx内容',
    '#(难逃法眼)检测文章是否由chatgpt生成',
    '#提问的智慧',
    '#文章续写',
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
    '#生成表格',
  ];
  String xdata = '';
  late AnimationController controller;

  bool _sending = false;
  bool _showAnimation = true;
  bool _isAtBottom = true;

  int _maxLines = 1; // 最多显示的行数

  @override
  void initState() {
    super.initState();
    Global.bottombarheight = 60;
    _messages.clear();
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Global.home_currentcolor,
            title: Text(
              '双击消息复制',
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
                    child: _messages.isEmpty
                        ? FadeInUp(
                            child: AnimatedOpacity(
                            opacity: _showAnimation ? 1.0 : 0.0,
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
                            itemCount: _messages.length,
                            itemBuilder: (BuildContext context, int index) {
                              String? sender = _messages[index]['sender'];
                              String? message = _messages[index]['message'];

                              return FadeInUp(
                                  child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.0),
                                child: GestureDetector(
                                  onDoubleTap: () {
                                    Clipboard.setData(
                                        ClipboardData(text: message));
                                    ScaffoldMessenger.of(context).showSnackBar(
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
                                              horizontal: 16.0, vertical: 8.0),
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
                                _showAnimation = true;
                                _messages.clear();
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
                                // decoration: InputDecoration.collapsed(
                                //   hintText: '输入消息...',
                                // ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          AnimatedBuilder(
                            // 包裹IconButton的AnimatedBuilder，用于构建进度指示器
                            animation: controller,
                            builder: (BuildContext context, Widget? child) {
                              return IconButton(
                                icon: _sending
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
                        bottomBarTheme: const BottomBarTheme(
                          decoration: BoxDecoration(color: Colors.white),
                          itemIconColor: Colors.grey,
                        ),
                        sheetChild: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Wrap(
                                spacing: 10,
                                children: _unselectedTags
                                    .map((e) => ActionChip(
                                          label: Text(e),
                                          onPressed: () {
                                            setState(() {
                                              _selectedTags.add(e);
                                              _unselectedTags.remove(e);
                                            });
                                          },
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                        items: const [
                          BottomBarWithSheetItem(icon: Icons.photo),
                          BottomBarWithSheetItem(icon: Icons.favorite),
                        ],
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
      _sending = true;
    });
    controller.repeat();

    _controller.clear();

    setState(() {
      _controller.clear();
      _messages.add({'sender': '我', 'message': message});
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
            _sending = false;
          });
          controller.reset();
          return;
        }
        setState(() {});
      });
      response.data.stream.listen((value) {
        if (xdata != '') _messages.removeLast();

        xdata += utf8.decode(value);
        xdata = xdata
            .replaceAll('AI:', '')
            .replaceAll('AI：', '')
            .replaceAll('机器人:', '')
            .replaceAll('机器人：', '')
            .replaceAll('Bot:', '')
            .replaceAll('Bot：', '');
        _messages.add({'sender': 'GPT', 'message': xdata});
        setState(() {
          if (_isAtBottom) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent);
            });
          }
          _showAnimation = false; // 当有消息时，停止显示动画
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

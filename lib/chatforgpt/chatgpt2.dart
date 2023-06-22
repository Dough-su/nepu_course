import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
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
import 'package:audio_waveforms/audio_waveforms.dart';

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
RecorderController recorderController = RecorderController(); // Initialise

class _ChatPageState extends State<ChatPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final RecorderController recorderController;

  String? path;
  String? musicFile;
  bool isRecording = false;
  bool isRecordingCompleted = false;
  bool isLoading = true;
  late Directory appDirectory;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final _bottomBarController = BottomBarWithSheetController(initialIndex: 0);
  final _selectedTags = <String>[];
  final _unselectedTags = <String>[
    '#翻译docx',
    '#对docx自定义操作',
    '#对长文章自定义操作',
    '#翻译长文章',
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
  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${appDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.m4a";
    isLoading = false;
    setState(() {});
  }

  void _startOrStopRecording() async {
    print('startOrStopRecording');
    _getDir();

    try {
      if (isRecording) {
        recorderController.reset();

        final path = await recorderController.stop(false); //停止录音
        print('path: $path');
        if (path != null) {
          addLoadingToMessages();
          isRecordingCompleted = true;
          debugPrint(path);
          debugPrint("Recorded file size: ${File(path).lengthSync()}");
          ApiService().sendvoiceToServer(path).then((value) => {
                messagess.removeLast(),
                print(value),
                _controller.text = value,
                sendmessage()
              });
        }
      } else {
        await recorderController.record(path: path!);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void _refreshWave() {
    if (isRecording) recorderController.refresh();
  }

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

    //如果e包含流程图则type为1,关系图为2, ER图为3, 实体关系图为4, 网络拓扑图为5, UML图为6, 时序图为7, 甘特图为8, 韦恩图为9, 树状图为10, 饼图为11
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
          // 500毫秒执行一次
          timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
            if (isTimeout) {
              timer.cancel();
              print('取消定时器');
              Global.messages_pure += "  " + xdata.toString() + ";";
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
                .replaceAll('', '')
                .replaceAll('', '')
                .replaceAll('', '')
                .replaceAll('', '')
                .replaceAll('', '')
                .replaceAll('', '');
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
      messagess.add({'sender': 'GPT', 'image': imageData});
      _textEditingController.clear();
    });
  }

  void _onConfirm(File file, String operation) {
    // 在这里处理文件和文本框的值
  }
  void addLoadingToMessages() {
    setState(() {
      messagess.add({'sender': 'GPT', 'loading': true});
    });
  }

  String xdata = '';
  late AnimationController controller;

  bool _isAtBottom = true;

  int _maxLines = 1; // 最多显示的行数

  @override
  void initState() {
    super.initState();
    _getDir();

    _initialiseControllers();

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
                          String prompt = _filteredStringList[index]["prompt"]!;
                          return RadioListTile(
                            title: Text("行为: $act"),
                            subtitle: Text("语句: $prompt"),
                            value: index,
                            groupValue: _selectedIndex,
                            onChanged: (int? value) {
                              setState(() {
                                _selectedIndex = value!;
                                _selectedValue =
                                    _filteredStringList[_selectedIndex]["act"];
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
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
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
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: messagess.length,
                            itemBuilder: (BuildContext context, int index) {
                              String? sender = messagess[index]['sender'];
                              String? message = messagess[index]['message'];
                              Uint8List? image = messagess[index]['image'];
                              bool? loading = messagess[index]['loading'];
                              if (loading != null && loading) {
                                return FadeInUp(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // 一个圆形的进度条
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
                                    child: Row(children: [
                                      Image.memory(
                                        image,
                                        //屏幕宽度-左右边距-图片左右边距
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          setState(() {
                                            messagess.removeAt(index);
                                            print(messagess);
                                          });
                                        },
                                      ),
                                    ]),
                                  ),
                                );
                              } else {
                                return FadeInUp(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 4.0),
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
                                          if (sender != '我')
                                            SizedBox(width: 8.0),
                                          Flexible(
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 8.0),
                                                  decoration: BoxDecoration(
                                                    color: sender == '我'
                                                        ? Global
                                                            .home_currentcolor
                                                        : Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.light
                                                            ? Colors.grey[200]
                                                            : Colors.grey[800],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: MarkdownBody(
                                                    selectable: true,
                                                    data: message!,
                                                  ),
                                                ),
                                                if (messagess.indexOf(
                                                            messagess[index]) ==
                                                        messagess.length - 1 &&
                                                    messagess[index]
                                                            ['sender'] !=
                                                        '我' &&
                                                    messagess[index]['image'] ==
                                                        null &&
                                                    messagess[index]
                                                            ['loading'] ==
                                                        null)
                                                  Row(children: [
                                                    TextButton(
                                                        onPressed: () {
                                                          _controller.text =
                                                              '继续';
                                                          sendmessage();
                                                        },
                                                        child: Text('继续')),
                                                    TextButton(
                                                        onPressed: () {
                                                          messagess.remove(
                                                              messagess[index]);

                                                          _controller.text =
                                                              messagess[index -
                                                                  1]['message'];
                                                          messagess.remove(
                                                              messagess[
                                                                  index - 1]);
                                                          sendmessage();
                                                        },
                                                        child: Text('重新生成')),
                                                    Text('当前字数' +
                                                        messagess[index]
                                                                ['message']
                                                            .length
                                                            .toString()),
                                                  ]),
                                              ],
                                            ),
                                          ),
                                          if (sender == '我')
                                            SizedBox(width: 8.0),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              setState(() {
                                                messagess.removeAt(index);
                                                print(messagess);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
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
                          // Expanded(
                          //   child: Container(
                          //     padding: EdgeInsets.symmetric(horizontal: 16.0),
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(20.0),
                          //     ),
                          //     child: TextField(
                          // focusNode: _focusNode,
                          // controller: _controller,
                          // onChanged: (value) {
                          //   final lines = value.split('\n').length;
                          //   setState(() {
                          //     if (lines <= 4) {
                          //       _maxLines = lines + 1;
                          //     } else
                          //       _maxLines = 4;
                          //   });
                          // },
                          // maxLines: _maxLines,
                          //     ),
                          //   ),
                          // ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: isRecording
                                ? AudioWaveforms(
                                    enableGesture: true,
                                    size: Size(
                                        MediaQuery.of(context).size.width / 2,
                                        50),
                                    recorderController: recorderController,
                                    waveStyle: const WaveStyle(
                                      waveColor: Colors.white,
                                      extendWaveform: true,
                                      showMiddleLine: false,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: Global.home_currentcolor,
                                    ),
                                    // padding: const EdgeInsets.only(left: 18),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                  )
                                : Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.8,
                                    decoration: BoxDecoration(
                                      color: Global.home_currentcolor,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: TextField(
                                      focusNode: _focusNode,
                                      controller: _controller,
                                      onChanged: (value) {
                                        final lines = value.split('\n').length;
                                        setState(() {
                                          if (lines <= 4) {
                                            _maxLines = lines + 1;
                                          } else
                                            _maxLines = 4;
                                        });
                                      },
                                      maxLines: _maxLines,
                                      decoration: InputDecoration(
                                        hintStyle: const TextStyle(
                                            color: Colors.white54),
                                        contentPadding:
                                            const EdgeInsets.only(top: 16),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                          ),
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
                          const SizedBox(width: 16),
                          IconButton(
                            onPressed: _startOrStopRecording,
                            icon: Icon(isRecording ? Icons.stop : Icons.mic),
                            color: Global.home_currentcolor,
                            iconSize: 28,
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
    recorderController.dispose();

    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  Future<void> sendmessage() async {
    String message = _controller.text.trim();

    if (message.isEmpty) return;
    if (message == '继续') {
      xdata = messagess[messagess.length - 1]['message'];
    }
    setState(() {
      sending = true;
    });
    controller.repeat();

    _controller.clear();
    if (message != '继续') {
      setState(() {
        _controller.clear();
        messagess.add({'sender': '我', 'message': message});
      });
    } else {
      _controller.clear();

      messagess.add({'sender': '我', 'message': message});
    }
    if (_isAtBottom) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }

    try {
      Response response = await ApiService().sendToServer(messagess);
      if (message == '继续') {
        messagess.removeLast();
      }
      Timer timer;
      bool isTimeout = false;
      // 500毫秒执行一次
      timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
        if (isTimeout) {
          timer.cancel();
          print('取消定时器');
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
            .replaceAll('GPT:', '')
            .replaceAll('AI: ', '')
            .replaceAll('GPT: ', '')
            .replaceAll('AI:', '')
            .replaceAll('GPT:', '');
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
    } catch (e) {}
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
  AchievementView(
    context,
    title: title,
    subTitle: subtitle,
    icon: icon,
    color: color,
    duration: Duration(seconds: second),
    isCircle: true,
    listener: (status) {},
  ).show();
}

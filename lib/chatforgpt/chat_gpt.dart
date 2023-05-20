import 'dart:async';

import 'package:achievement_view/achievement_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:muse_nepu_course/chat/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:muse_nepu_course/global.dart';
import 'package:muse_nepu_course/home.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mime/mime.dart';
import 'package:flutter/services.dart'
    show Clipboard, ClipboardData, Uint8List, rootBundle;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class chat_gpt extends StatefulWidget {
  @override
  _chat_gptState createState() => _chat_gptState();
}

var _filteredStringList = [];
var _stringList = [];
int _selectedIndex = -1;
String? _selectedValue;

class _chat_gptState extends State<chat_gpt> {
  StreamController<List<types.Message>> _streamController = StreamController();
  late String xdata = '';
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );

  //从assets/prompts.json中读取数据,并转换为List<Map<String, String>>
  void loadprompts() async {
    String prompt = await rootBundle.loadString('assets/prompts.json');
    _stringList = json.decode(prompt);
    _filteredStringList = List.from(_stringList);
  }

  int getindex() {
    return _selectedIndex;
  }

  @override
  void initState() {
    super.initState();
    Global.bottombarheight = 60;

    Dio dio = Dio();
    dio
        .get('https://chatgpt-chatgpt-lswirmtbkx.us-east-1.fcapp.run/')
        .then((response) {
      print(response.data);
    });
    _loadMessages();
    loadprompts();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('双击对话复制'),
        //加入返回按鈕
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //跳转到主页面
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HomePage();
            }));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Scaffold(
                        appBar: AppBar(
                          title: Text('自动注入消息'),
                          actions: [
                            IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                print(Global.messages_pure);
                              },
                            ),
                          ],
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
                                  final textMessage = types.TextMessage(
                                    author: _user,
                                    createdAt:
                                        DateTime.now().millisecondsSinceEpoch,
                                    id: const Uuid().v4(),
                                    text: _filteredStringList[_selectedIndex]
                                        ["prompt"],
                                  );

                                  _addMessage(textMessage);

                                  sendtoserver(
                                    textMessage.text,
                                  );

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
      body: Chat(
        messages: Global.messages,
        onAttachmentPressed: _handleAttachmentPressed,
        onMessageTap: _handleMessageTap,
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: _handleSendPressed,
        onMessageDoubleTap: _handleMessageDoubleTap,
        showUserAvatars: true,
        l10n: ChatL10nZhCN(),
        //Widget Function(CustomMessage, {required int messageWidth})? customMessageBuilder,
        customMessageBuilder: (p0, {required messageWidth}) {
          //自定义消息
          return StreamBuilder(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: Text(snapshot.data.toString()),
                );
              } else {
                return Center(
                  child: Text('Waiting for data...'),
                );
              }
            },

            // return Container(
            //   width: messageWidth.toDouble(),
            //   child: Markdown(
            //     data: '111',
            //     selectable: true,
            //   ),
          );
        },
        showUserNames: true,
        user: _user,
      ),
    );
  }

  void sendtoserver(message) async {
    setState(() {
      Global.messages.insert(
          0,
          types.TextMessage(
            author: types.User(id: '131231-322-4a89-ae75-a22bf8d6f3ac'),
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: //随机生成id
                const Uuid().v4(),
            text: '等待回复中...',
          ));
    });
    Global.messages_pure += "human: '" + message + "';";
    int tokenCount = Global.messages_pure.split(" ").map((word) {
      if (RegExp(r"[\u4e00-\u9fa5]").hasMatch(word)) {
        return (word.length * 2.5).ceil();
      } else {
        return 1;
      }
    }).reduce((a, b) => a + b);

    if (tokenCount > 7000) {
      print("超过了7000个token" + tokenCount.toString());
      while (tokenCount > 7000) {
        Global.messages_pure = Global.messages_pure
            .substring(Global.messages_pure.indexOf(";") + 1);
        tokenCount = Global.messages_pure.split(" ").map((word) {
          if (RegExp(r"[\u4e00-\u9fa5]").hasMatch(word)) {
            return (word.length * 2.5).ceil();
          } else {
            return 1;
          }
        }).reduce((a, b) => a + b);
      }
      print("截取后的token" + tokenCount.toString());
    } else {
      print("未超过7000个token" + tokenCount.toString());
    }
    Dio dio = new Dio();

    var headers = {'User-Agent': 'Apifox/1.0.0 (https://www.apifox.cn)'};

    FormData formData = FormData.fromMap({
      'content': Global.messages_pure,
    });

    try {
      Response response = await Dio().post(
        'https://chatgpt-chatgpt-lswirmtbkx.us-east-1.fcapp.run/test',
        data: formData,
        options: Options(
          headers: headers,
          responseType: ResponseType.stream,
        ),
      );

      Timer timer;
      bool isTimeout = false;
      //500毫秒执行一次
      timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
        if (isTimeout) {
          timer.cancel();
          print('取消定时器');
          Global.messages_pure += " AI: '" + xdata.toString() + "';";
          setState(() {});
          xdata = ' ';
          return;
        }
        setState(() {}); //每次执行完函数更新状态
      });
      response.data.stream.listen((value) {
        xdata += utf8.decode(value);
        Global.messages[0] = types.TextMessage(
          author: types.User(id: '131231-322-4a89-ae75-a22bf8d6f3ac'),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          text: xdata,
        );
      }, onDone: () {
        print('数据接收完毕');
        isTimeout = true;
      });
    } catch (e) {
      print(e);
    }
  }

  void _addMessage(types.Message message) {
    setState(() {
      Global.messages.insert(0, message);
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //加入文字提示
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(start: 16, top: 16),
                  child: Text('以下方式目前不可用，仅作为占位，未来如果api允许，会加入'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('照片'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('文件'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('取消'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );
      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              Global.messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (Global.messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            Global.messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              Global.messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (Global.messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            Global.messages[index] = updatedMessage;
          });
        }
      }
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index =
        Global.messages.indexWhere((element) => element.id == message.id);
    final updatedMessage =
        (Global.messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      Global.messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
    print(message.text);
    sendtoserver(message.text);
  }

  //(BuildContext context, types.Message)
  void _handleMessageDoubleTap(BuildContext context, types.Message message) {
    var msgjson = message.toJson();
    //复制到剪贴板
    Clipboard.setData(ClipboardData(text: msgjson['text']));
    AchievementView(context,
        title: "复制成功",
        subTitle: '已复制到剪贴板',
        //onTab: _onTabAchievement,
        icon: Icon(
          Icons.insert_emoticon,
          color: Colors.white,
        ),
        color: Colors.green,
        duration: Duration(seconds: 3),
        isCircle: true, listener: (status) {
      print(status);
    })
      ..show();
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      Global.messages = messages;
    });
  }
}

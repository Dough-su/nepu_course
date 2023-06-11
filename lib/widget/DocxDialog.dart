import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:muse_nepu_course/chatforgpt/chatgpt2.dart';
import 'package:muse_nepu_course/global.dart';

class DocxDialog extends StatefulWidget {
  final Function(Map<String, dynamic> status) onUploadSuccess;
  final Widget? customContentWidget;
  final Function(void Function()) externalSetState;

  DocxDialog({
    required this.onUploadSuccess,
    this.customContentWidget,
    required this.externalSetState,
  });

  @override
  _DocxDialogState createState() => _DocxDialogState();
}

class _DocxDialogState extends State<DocxDialog> {
  TextEditingController _textEditingController = TextEditingController();
  StreamController streamController = StreamController();
  late File _file;
  String? _fileName;
  bool _isUploading = false;

  void initState() {
    super.initState();
    // 开始接收消息时，关闭弹窗
    // streamController.stream.listen((event) {
    //   Navigator.pop(context);
    // });
  }

  Future<void> _uploadFile() async {
    if (_isUploading) {
      return;
    }
    _isUploading = true;

    if (_file == null) {
      return;
    }

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(_file.path),
      'content': _textEditingController.text,
    });
    print('需要操作' + _textEditingController.text);

    final dio = Dio();
    Response response = await dio.post(
      'https://chatgpt-chatgpt-lswirmtbkx.us-east-1.fcapp.run/upload',
      data: formData,
      options: Options(
        responseType: ResponseType.stream,
      ),
    );

    // 重置状态
    widget.externalSetState(() {
      _file = File('');
      _fileName = null;
      _textEditingController.text = '';
      _isUploading = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('上传成功'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // 传递状态信息给外部
              widget.onUploadSuccess({
                'status': 'success',
                'message': '文件上传成功',
              });
            },
            child: Text('确定'),
          ),
        ],
      ),
    );

    String xdata = '';
    Timer timer;
    bool isTimeout = false;
    //500毫秒执行一次
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (isTimeout) {
        timer.cancel();
        print('取消定时器');
        Global.messages_pure += " AI: " + xdata.toString() + ";";
        widget.externalSetState(() {});
        xdata = '';
        widget.externalSetState(() {
          sending = false;
        });
        return;
      }
      widget.externalSetState(() {});
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
      widget.externalSetState(() {
        showAnimation = false; // 当有消息时，停止显示动画
      });
    }, onDone: () {
      print('数据接收完毕');
      isTimeout = true;

      widget.externalSetState(() {});
    });
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['docx'],
    );

    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
        _fileName = _file.path.split('/').last;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('选择一个docx文件'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.customContentWidget != null) widget.customContentWidget!,
          ElevatedButton(
            onPressed: _pickFile,
            child: Text('选择文件'),
          ),
          if (_fileName != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(_fileName!),
            ),
          TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: '请输入docx文件的操作',
            ),
          ),
          // 无限横向条
          SizedBox(height: 16),
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
            child: AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.linear,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
      // 当上传按钮被按下时，关闭弹窗
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            _uploadFile();
            // Navigator.pop(context);
          },
          child: Text('上传'),
        ),
      ],
    );
  }
}

Future<void> uploadFile(
  BuildContext context,
  File file,
  String content,
  Function onUploadSuccess,
  Function(void Function()) externalSetState,
) async {
  final formData = FormData.fromMap({
    'file': await MultipartFile.fromFile(file.path),
    'content': content,
  });

  final dio = Dio();
  Response response = await dio.post(
    'https://chatgpt-chatgpt-lswirmtbkx.us-east-1.fcapp.run/upload',
    data: formData,
    options: Options(
      responseType: ResponseType.stream,
    ),
  );

  String xdata = '';
  Timer timer;
  bool isTimeout = false;
  //500毫秒执行一次
  timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
    if (isTimeout) {
      timer.cancel();
      print('取消定时器');
      Global.messages_pure += " AI: " + xdata.toString() + ";";
      externalSetState(() {});
      xdata = '';
      externalSetState(() {
        sending = false;
      });
      return;
    }
    externalSetState(() {});
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
    externalSetState(() {
      showAnimation = false; // 当有消息时，停止显示动画
    });
  }, onDone: () {
    print('数据接收完毕');
    isTimeout = true;
    onUploadSuccess();
    externalSetState(() {});
  });
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:muse_nepu_course/page/ChatgptPage.dart';
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
  bool _uploading = false;
  double _uploadProgress = 0.0;
  late File _file;
  String? _fileName;
  TextEditingController _textEditingController = TextEditingController();
  StreamController streamController = StreamController();
  bool isfirst = true;
  Future<void> _uploadFile() async {
    if (_uploading) {
      return;
    }
    setState(() {
      _uploading = true;
    });

    if (_file == null) {
      return;
    }
    @override
    void initState() {
      super.initState();
      streamController.stream.listen((event) {});
    }

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(_file.path),
      'content': _textEditingController.text,
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
      if (isfirst) {
        isfirst = false;
        setState(() {
          _uploading = false;
          Navigator.pop(context);
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
      }
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

    response.data.stream.listen((value) {
      _uploadProgress = (value.length / response.data.contentLength) * 100;
      setState(() {});
    }, onDone: () {});
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
          if (_uploading)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  value: _uploadProgress,
                  strokeWidth: 3,
                ),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            // 传递状态信息给外部
            widget.onUploadSuccess({
              'status': 'cancel',
              'message': '文件上传已取消',
            });
          },
          child: Text('取消'),
        ),
        ElevatedButton(
          onPressed: _uploading ? null : _uploadFile,
          child: _uploading ? Text('上传中...') : Text('上传'),
        ),
      ],
    );
  }
}

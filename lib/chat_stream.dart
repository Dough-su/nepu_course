import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class StreamPage extends StatefulWidget {
  @override
  _StreamPageState createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {
  StreamController<String> _streamController = StreamController();
  late String xdata = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Stream Example'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              _getData();
            },
          )),
      body: StreamBuilder(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Text(snapshot.data!),
            );
          } else {
            return Center(
              child: Text('Waiting for data...'),
            );
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void _getData() async {
    Response response = await Dio().post(
      'http://127.0.0.1:5000/test',
      data: {'content': '1111'},
      options: Options(
        responseType: ResponseType.stream,
      ),
    );
    print(response.data);

    response.data.stream
        .transform(StreamTransformer<Uint8List, String>.fromHandlers(
      handleData: (data, sink) {
        sink.add(utf8.decode(data));
      },
    )).listen((data) {
      xdata += data;

      _streamController.add(xdata);
    });
  }
}

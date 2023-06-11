import 'package:flutter/material.dart';

class MyDialog extends StatefulWidget {
  final String hint1;
  final String hint2;

  MyDialog({required this.hint1, required this.hint2});

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final _textController1 = TextEditingController();
  final _textController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('输入文本'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _textController1,
              decoration: InputDecoration(hintText: widget.hint1),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _textController2,
              decoration: InputDecoration(hintText: widget.hint2),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('取消'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('确定'),
          onPressed: () {
            final result = {
              'text1': _textController1.text,
              'text2': _textController2.text,
            };
            Navigator.of(context).pop(result);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textController1.dispose();
    _textController2.dispose();
    super.dispose();
  }
}

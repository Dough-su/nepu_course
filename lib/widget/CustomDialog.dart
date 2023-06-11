import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final Function(String)? onConfirm;

  CustomDialog({
    required this.title,
    required this.hintText,
    required this.controller,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            '请在下方填入你要生成的图片描述，一张图大概10s-20s左右',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
            ),
          ),
          SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('取消'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (onConfirm != null) {
                    onConfirm!(controller.text);
                  }
                  Navigator.of(context).pop();
                },
                child: Text('确定'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

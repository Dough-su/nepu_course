import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InstagramPostPage extends StatefulWidget {
  @override
  _InstagramPostPageState createState() => _InstagramPostPageState();
}

class _InstagramPostPageState extends State<InstagramPostPage> {
  List<XFile> _imageList = [];
  String _caption = '';

  Future<void> _pickImages() async {
    final pickedImages = await ImagePicker().pickMultiImage(imageQuality: 50);
    setState(() {
      _imageList = pickedImages ?? [];
    });
  }

  Future<void> _post() async {
    // 进行发帖操作，上传图片和文字
    // 发帖成功后返回主页
    Navigator.pop(context);
  }

  Widget _buildImagePreview() {
    return Container(
      height: 200.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _imageList.length,
        itemBuilder: (BuildContext context, int index) {
          final XFile image = _imageList[index];
          return Container(
            margin: EdgeInsets.all(8.0),
            child: Image.file(
              File(image.path),
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
        actions: [
          TextButton(
            onPressed: _post,
            child: Text(
              'Post',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _imageList.isEmpty
                ? Container(
                    height: 200.0,
                    color: Colors.grey[300],
                    child: Icon(Icons.photo_camera),
                    alignment: Alignment.center,
                  )
                : _buildImagePreview(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _caption = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Write a caption...',
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImages,
        child: Icon(Icons.add_photo_alternate),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class InstagramPostDetailPage extends StatelessWidget {
  final String imageUrl;
  final String content;

  InstagramPostDetailPage({required this.imageUrl, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Detail'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imageUrl),
          SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(content),
          ),
        ],
      ),
    );
  }
}

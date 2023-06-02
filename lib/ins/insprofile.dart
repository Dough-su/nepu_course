import 'package:flutter/material.dart';
import 'package:muse_nepu_course/ins.dart';
import 'package:muse_nepu_course/ins/inspostdetialpage.dart';

class InstagramPost extends StatelessWidget {
  final String imageUrl;
  final String content;

  InstagramPost({required this.imageUrl, required this.content});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => InstagramPostDetailPage(
              imageUrl: imageUrl,
              content: content,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
              ),
              child: Text(
                content,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InstagramProfilePage extends StatefulWidget {
  final String userId; // 添加userId属性
  InstagramProfilePage({required this.userId}); // 接收userId参数
  @override
  _InstagramProfilePageState createState() => _InstagramProfilePageState();
}

class _InstagramProfilePageState extends State<InstagramProfilePage> {
  String _username = 'muse';
  int _postsCount = 10;
  int _followersCount = 100;
  int _followingCount = 50;
  List<Post> _posts = [
    Post(
      id: '1', // 为每个帖子赋一个唯一的id
      username: 'username1',
      profileImageUrl: 'https://picsum.photos/id/1005/100/100',
      isFollowed: true,

      content: 'This is a post', // 添加内容属性
      imageUrls: [
        'https://picsum.photos/id/237/200/300',
        'https://picsum.photos/id/238/200/300',
        'https://picsum.photos/id/239/200/300',
      ],
      likes: 10,
      comments: 2,
      reposts: 3,
      saves: 5,
      isLiked: false,
      isSaved: false,
    ),
    Post(
      id: '2', // 为每个帖子赋一个唯一的id
      username: 'username2',
      profileImageUrl: 'https://picsum.photos/id/1006/100/100',
      isFollowed: true,

      content: 'This is a post', // 添加内容属性

      imageUrls: [
        'https://picsum.photos/id/240/200/300',
        'https://picsum.photos/id/241/200/300',
        'https://picsum.photos/id/242/200/300',
      ],
      likes: 20,
      comments: 4,
      reposts: 6,
      saves: 8,
      isLiked: false,
      isSaved: false,
    ),
    Post(
      id: '3', // 为每个帖子赋一个唯一的id
      username: 'username3',
      content: 'This is a post', // 添加内容属性
      isFollowed: true,

      profileImageUrl: 'https://picsum.photos/id/1007/100/100',
      imageUrls: [
        'https://picsum.photos/id/243/200/300',
        'https://picsum.photos/id/244/200/300',
        'https://picsum.photos/id/245/200/300',
      ],
      likes: 30,
      comments: 6,
      reposts: 9,
      saves: 12,
      isLiked: false,
      isSaved: false,
    ),
  ];
  List<String> _postImageUrls = [
    'https://picsum.photos/id/237/200/300',
    'https://picsum.photos/id/238/200/300',
    'https://picsum.photos/id/239/200/300',
    'https://picsum.photos/id/240/200/300',
    'https://picsum.photos/id/241/200/300',
    'https://picsum.photos/id/242/200/300',
    'https://picsum.photos/id/243/200/300',
    'https://picsum.photos/id/244/200/300',
    'https://picsum.photos/id/245/200/300',
    'https://picsum.photos/id/246/200/300',
    'https://picsum.photos/id/247/200/300',
    'https://picsum.photos/id/248/200/300',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_username),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage('https://picsum.photos/id/237/200/300'),
                  radius: 50.0,
                ),
                Row(
                  children: [
                    Text(
                      '$_postsCount\nPosts',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      '$_followersCount\nFollowers',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      '$_followingCount\nFollowing',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: _posts.length,
              itemBuilder: (BuildContext context, int index) {
                return InstagramPost(
                  imageUrl: _posts[index].imageUrls[0],
                  content: _posts[index].content,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:muse_nepu_course/ins/insComment.dart';
import 'package:muse_nepu_course/ins/inspostpage.dart';
import 'package:muse_nepu_course/ins/insprofile.dart';

class Post {
  final String id;
  final String username;
  final String profileImageUrl;
  final List<String> imageUrls;
  final String content; // 添加内容属性
  late final bool isFollowed;
  int likes;
  int comments;
  int reposts;
  int saves;
  bool isLiked;
  bool isSaved;

  Post({
    required this.id,
    required this.username,
    required this.profileImageUrl,
    required this.imageUrls,
    required this.content, // 添加内容属性
    required this.isFollowed,
    this.likes = 0,
    this.comments = 0,
    this.reposts = 0,
    this.saves = 0,
    this.isLiked = false,
    this.isSaved = false,
  });
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      username: json['username'],
      profileImageUrl: json['profile_image_url'],
      imageUrls: List<String>.from(json['image_urls']),
      content: json['content'],
      isFollowed: json['isFollowed'],
      likes: json['likes'],
      comments: json['comments'],
      // ...
    );
  }
}

class InstagramHomePage extends StatefulWidget {
  @override
  _InstagramHomePageState createState() => _InstagramHomePageState();
}

class _InstagramHomePageState extends State<InstagramHomePage> {
  List<Post> _posts = [
    Post(
      id: '1', // 为每个帖子赋一个唯一的id
      username: 'username1',
      profileImageUrl: 'https://picsum.photos/id/1005/100/100',
      content: 'This is a post', // 添加内容属性
      isFollowed: true,
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
      content: 'This is a post', // 添加内容属性
      isFollowed: false,

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

  void _likePost(int index) {
    setState(() {
      _posts[index].isLiked = !_posts[index].isLiked;
      if (_posts[index].isLiked) {
        _posts[index].likes++;
      } else {
        _posts[index].likes--;
      }
    });
  }

  void _savePost(int index) {
    setState(() {
      _posts[index].isSaved = !_posts[index].isSaved;
      if (_posts[index].isSaved) {
        _posts[index].saves++;
      } else {
        _posts[index].saves--;
      }
    });
  }

  Widget _buildPost(Post post, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      // 在这里触发关注操作
                      setState(() {
                        post.isFollowed = !post.isFollowed;
                      });
                      if (post.isFollowed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('关注成功'),
                          ),
                        );
                      }
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(post.profileImageUrl),
                      radius: 20.0,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    post.username,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              //增加一个关注按钮
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    post.isFollowed = !post.isFollowed;
                  });
                  if (post.isFollowed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('关注成功'),
                      ),
                    );
                  }
                },
                child: Text(
                  post.isFollowed ? '已关注' : '关注',
                  style: TextStyle(
                    color: post.isFollowed ? Colors.black : Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: post.isFollowed ? Colors.grey[300] : Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        CarouselSlider(
          options: CarouselOptions(
            height: 300.0,
            aspectRatio: 16 / 9,
            viewportFraction: 0.9,
            initialPage: 0,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {},
            scrollDirection: Axis.horizontal,
          ),
          items: post.imageUrls.map((imageUrl) {
            return Container(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            );
          }).toList(),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.content), // 显示帖子内容
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          post.isLiked ? Icons.favorite : Icons.favorite_border,
                          color: post.isLiked ? Colors.red : null,
                        ),
                        onPressed: () {
                          _likePost(index);
                        },
                      ),
                      Text(post.likes.toString()),
                      SizedBox(width: 10.0),
                      IconButton(
                        icon: Icon(Icons.chat_bubble_outline),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  CommentPage(postId: post.id),
                            ),
                          );
                        },
                      ),
                      Text(post.comments.toString()),
                      SizedBox(width: 10.0),
                      IconButton(
                        icon: Icon(Icons.repeat),
                        onPressed: () {},
                      ),
                      Text(post.reposts.toString()),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        post.isSaved = !post.isSaved;
                        if (post.isSaved) {
                          post.saves++;
                        } else {
                          post.saves--;
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          post.isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: post.isSaved ? Colors.blue : null,
                        ),
                        SizedBox(width: 5.0),
                        Text(post.saves.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Instagram_logo.svg/1200px-Instagram_logo.svg.png',
            height: 40,
            width: 40,
          ),
        ),
        title: Text(''),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => InstagramPostPage(),
                ),
              );
            },
            color: Colors.black,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildPost(_posts[index], index);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Likes',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        InstagramProfilePage(userId: '111'),
                  ),
                );
              },
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

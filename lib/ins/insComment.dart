import 'package:flutter/material.dart';

class Comment {
  final String username;
  final String profileImageUrl;
  final String text;
  int likes;
  int replies;
  bool isLiked;
  List<Comment> replyList;
  Comment? parentComment; // 添加父级评论属性

  Comment({
    required this.username,
    required this.profileImageUrl,
    required this.text,
    this.likes = 0,
    this.replies = 0,
    this.isLiked = false,
    List<Comment>? repliess,
    Comment? parentComment, // 添加父级评论参数
  })  : replyList = repliess ?? [],
        parentComment = parentComment;
}

class CommentPage extends StatefulWidget {
  final String postId;
  CommentPage({required this.postId});
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  List<Comment> _comments = []; // 将 _comments 的初始化移动到 initState 方法中

  @override
  void initState() {
    super.initState();
    _comments = [
      Comment(
        username: 'user1',
        profileImageUrl: 'https://picsum.photos/id/1005/100/100',
        text: 'Comment 1',
        likes: 10,
        replies: 2,
        isLiked: false,
        repliess: [
          Comment(
            username: 'user2',
            profileImageUrl: 'https://picsum.photos/id/1006/100/100',
            text: 'Reply to Comment 1',
            likes: 5,
            isLiked: false,
          ),
          Comment(
            username: 'user3',
            profileImageUrl: 'https://picsum.photos/id/1007/100/100',
            text: 'Another reply to Comment 1',
            likes: 3,
            isLiked: false,
          ),
        ],
      ),
      Comment(
        username: 'user2',
        profileImageUrl: 'https://picsum.photos/id/1006/100/100',
        text: 'Comment 2',
        likes: 20,
        replies: 4,
        isLiked: false,
      ),
      Comment(
        username: 'user3',
        profileImageUrl: 'https://picsum.photos/id/1007/100/100',
        text: 'Comment 3',
        likes: 30,
        replies: 6,
        isLiked: false,
        repliess: [
          Comment(
            username: 'user1',
            profileImageUrl: 'https://picsum.photos/id/1005/100/100',
            text: 'Reply to Comment 3',
            likes: 9,
            isLiked: false,
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _comments.length,
              itemBuilder: (BuildContext context, int index) {
                Comment comment = _comments[index];
                return _buildCommentListItem(comment);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Leave a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Comment'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentListItem(Comment comment) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(comment.profileImageUrl),
          ),
          title: Text(comment.username),
          subtitle: Text(
            '${comment.likes} likes • ${comment.replies} replies • 1 hour ago',
          ),
          trailing: IconButton(
            icon:
                Icon(comment.isLiked ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() {
                comment.isLiked = !comment.isLiked;
                if (comment.isLiked) {
                  comment.likes++;
                } else {
                  comment.likes--;
                }
              });
            },
          ),
          onTap: () {
            setState(() {
              if (comment.replyList.isNotEmpty) {
                comment.replyList = [];
              } else {
                _showReplyDialog(context, comment);
              }
            });
          },
        ),
        if (comment.replyList.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 72.0),
            child: Column(
              children: comment.replyList
                  .map((reply) =>
                      _buildCommentListItem(reply)) // 在这里省略了一些代码，应该补全
                  .toList(),
            ),
          ),
      ],
    );
  }

  _showReplyDialog(BuildContext context, Comment parentComment) {
    String replyText = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reply to ${parentComment.username}'),
          content: TextField(
            onChanged: (value) {
              replyText = value;
            },
            decoration: InputDecoration(hintText: 'Type your reply here...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Comment newReply = Comment(
                  username: 'You',
                  profileImageUrl: '',
                  text: replyText,
                  likes: 0,
                  replies: 0,
                  isLiked: false,
                );
                setState(() {
                  parentComment.replyList.add(newReply);
                  parentComment.replies++;
                });
                Navigator.pop(context);
              },
              child: Text('Reply'),
            ),
          ],
        );
      },
    );
  }
}

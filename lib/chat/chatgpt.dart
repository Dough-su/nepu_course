import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:chatview/chatview.dart';
import 'package:muse_nepu_course/chat/theme.dart';
import 'package:muse_nepu_course/home.dart';

import '../global.dart';

class chatgpt extends StatefulWidget {
  @override
  _chatgptState createState() => _chatgptState();
}

bool texting = false;

class _chatgptState extends State<chatgpt> {
  AppTheme theme = LightTheme();
  bool isDarkTheme = false;
  String getmessage() {
    setState(() {
      texting = true;
    });
    String message = '';
    //只读取倒数20条消息，如果消息数小于20条则全部读取
    int start = 1;
    if (Global.messageList.length > 40) {
      start = Global.messageList.length - 40;
    } else {
      start = 1;
    }
    for (int i = start; i < Global.messageList.length; i++) {
      //判断sendBy是不是自己，如果是自己则在对话前加上human:，否则加上robot:
      if (Global.messageList[i].sendBy == '1') {
        message = message + 'human:' + Global.messageList[i].message + ' ';
      } else {
        message = message + 'chatgpt:' + Global.messageList[i].message + ' ';
      }
    }
    return message;
  }

  void sendtoserver() async {
    Dio dio = Dio();
    dio.options.connectTimeout = 60000; // 设置连接超时时间为60秒
    dio.options.receiveTimeout = 60000; // 设置接收超时时间为60秒

    try {
      final response = await dio.get(
          'https://chatgpt-chatgpt-lswirmtbkx.us-east-1.fcapp.run/?content=' +
              getmessage());
      if (response.data.toString() == '') {
        response.data = '服务有些繁忙哦，请再试一次吧';
      }
      print(response.data.toString());

      Global.messageList.add(Message(
        id: '1',
        message: response.data.toString(),
        createdAt: DateTime.now(),
        sendBy: '2',
      ));
      setState(() {
        texting = false;
      });
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        // 处理超时事件
        Global.messageList.add(Message(
          id: '1',
          message: '服务有些繁忙哦，请再试一次哦',
          createdAt: DateTime.now(),
          sendBy: '2',
        ));
        setState(() {
          texting = false;
        });
      } else {
        print(e);
      }
    }
  }

  final chatController = ChatController(
    initialMessageList: Global.messageList,
    scrollController: ScrollController(),
  );

  @override
  void initState() {
    super.initState();
    texting = false;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatView(
        showTypingIndicator: texting,
        sender: ChatUser(id: '1', name: '我'),
        receiver: ChatUser(id: '2', name: 'chatgpt'),
        chatController: chatController,
        onSendTap: onSendTap,
        typeIndicatorConfig: TypeIndicatorConfiguration(
          flashingCircleBrightColor: theme.flashingCircleBrightColor,
          flashingCircleDarkColor: theme.flashingCircleDarkColor,
        ),
        appBar: ChatViewAppBar(
          elevation: theme.elevation,
          onBackPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          backGroundColor: theme.appBarColor,
          backArrowColor: theme.backArrowColor,
          title: "chatgpt",
          titleTextStyle: TextStyle(
            color: theme.appBarTitleTextStyle,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 0.25,
          ),
          userStatus: "在线",
          userStatusTextStyle: const TextStyle(color: Colors.grey),
          actions: [
            IconButton(
              onPressed: onThemeIconTap,
              icon: Icon(
                isDarkTheme
                    ? Icons.brightness_4_outlined
                    : Icons.dark_mode_outlined,
                color: theme.themeIconColor,
              ),
            ),
          ],
        ),
        chatBackgroundConfig: ChatBackgroundConfiguration(
          horizontalDragToShowMessageTime: true,
          messageTimeIconColor: theme.messageTimeIconColor,
          messageTimeTextStyle: TextStyle(color: theme.messageTimeTextColor),
          defaultGroupSeparatorConfig: DefaultGroupSeparatorConfiguration(
            textStyle: TextStyle(
              color: theme.chatHeaderColor,
              fontSize: 17,
            ),
          ),
          backgroundColor: theme.backgroundColor,
        ),
        sendMessageConfig: SendMessageConfiguration(
          imagePickerIconsConfig: ImagePickerIconsConfiguration(
            cameraIconColor: theme.cameraIconColor,
            galleryIconColor: theme.galleryIconColor,
          ),
          replyMessageColor: theme.replyMessageColor,
          defaultSendButtonColor: theme.sendButtonColor,
          replyDialogColor: theme.replyDialogColor,
          replyTitleColor: theme.replyTitleColor,
          textFieldBackgroundColor: theme.textFieldBackgroundColor,
          closeIconColor: theme.closeIconColor,
          textFieldConfig: TextFieldConfiguration(
            textStyle: TextStyle(color: theme.textFieldTextColor),
          ),
        ),
        chatBubbleConfig: ChatBubbleConfiguration(
          outgoingChatBubbleConfig: ChatBubble(
            linkPreviewConfig: LinkPreviewConfiguration(
              backgroundColor: theme.linkPreviewOutgoingChatColor,
              bodyStyle: theme.outgoingChatLinkBodyStyle,
              titleStyle: theme.outgoingChatLinkTitleStyle,
            ),
            color: theme.outgoingChatBubbleColor,
          ),
          inComingChatBubbleConfig: ChatBubble(
            linkPreviewConfig: LinkPreviewConfiguration(
              linkStyle: TextStyle(
                color: theme.inComingChatBubbleTextColor,
                decoration: TextDecoration.underline,
              ),
              backgroundColor: theme.linkPreviewIncomingChatColor,
              bodyStyle: theme.incomingChatLinkBodyStyle,
              titleStyle: theme.incomingChatLinkTitleStyle,
            ),
            textStyle: TextStyle(color: theme.inComingChatBubbleTextColor),
            color: theme.inComingChatBubbleColor,
          ),
        ),
        replyPopupConfig: ReplyPopupConfiguration(
          //回复弹窗配置
          backgroundColor: theme.replyPopupColor,
          buttonTextStyle: TextStyle(color: theme.replyPopupButtonColor),
          topBorderColor: theme.replyPopupTopBorderColor,
        ),
        reactionPopupConfig: ReactionPopupConfiguration(
          //表情弹窗配置
          showGlassMorphismEffect: true, //
          shadow: BoxShadow(
            color: isDarkTheme ? Colors.black54 : Colors.grey.shade400,
            blurRadius: 20,
          ),
          backgroundColor: theme.reactionPopupColor,
          onEmojiTap: chatController.setReaction,
        ),
        messageConfig: MessageConfiguration(
          messageReactionConfig: MessageReactionConfiguration(
            backgroundColor: theme.messageReactionBackGroundColor,
            borderColor: theme.messageReactionBackGroundColor,
          ),
          imageMessageConfig: ImageMessageConfiguration(
            shareIconConfig: ShareIconConfiguration(
              defaultIconBackgroundColor: theme.shareIconBackgroundColor,
              defaultIconColor: theme.shareIconColor,
            ),
          ),
        ),
        swipeToReplyConfig: SwipeToReplyConfiguration(
          replyIconColor: theme.swipeToReplyIconColor,
        ),
      ),
    );
  }
  //我想给chatview配置一个等待动画

  void onSendTap(String message, ReplyMessage replyMessage) {
    //replyMessage是回复的消息
    chatController.addMessage(
      Message(
        createdAt: DateTime.now(),
        message: message,
        sendBy: '1',
        replyMessage: replyMessage,
      ),
    );
    sendtoserver();
  }

  void onThemeIconTap() {
    setState(() {
      if (isDarkTheme) {
        theme = LightTheme();
        isDarkTheme = false;
      } else {
        theme = DarkTheme();
        isDarkTheme = true;
      }
    });
  }
}

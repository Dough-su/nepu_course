/*
 * Copyright (c) 2022 Simform Solutions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import 'package:muse_nepu_course/chatview/src/models/reply_message.dart';
import 'package:muse_nepu_course/chatview/src/values/enumaration.dart';

class Message {
  final String id;
  final String message;
  final DateTime createdAt;
  final String sendBy;
  final ReplyMessage replyMessage;
  final String reaction;
  final MessageType messageType;

  Message({
    this.id = '',
    required this.message,
    required this.createdAt,
    required this.sendBy,
    ReplyMessage? replyMessage,
    this.reaction = '',
    this.messageType = MessageType.text,
  }) : replyMessage = replyMessage ?? ReplyMessage();

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        message: json["message"],
        createdAt: json["createdAt"],
        sendBy: json["sendBy"],
        replyMessage: ReplyMessage.fromJson(json["reply_message"]),
        reaction: json["reaction"] ?? '',
        messageType: json["message_type"],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
        'createdAt': createdAt,
        'sendBy': sendBy,
        'reply_message': replyMessage.toJson(),
        'reaction': reaction,
        'message_type': messageType,
      };
}

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
import 'package:flutter/material.dart';

import 'package:muse_nepu_course/chatview/src/extensions/extensions.dart';
import 'package:muse_nepu_course/chatview/src/models/models.dart';
import 'package:muse_nepu_course/chatview/src/utils/package_strings.dart';

import '../utils/constants.dart';
import 'vertical_line.dart';

class ReplyMessageWidget extends StatelessWidget {
  const ReplyMessageWidget({
    Key? key,
    required this.message,
    this.repliedMessageConfig,
    required this.sender,
    required this.receiver,
  }) : super(key: key);

  final Message message;
  final RepliedMessageConfiguration? repliedMessageConfig;
  final ChatUser sender;
  final ChatUser receiver;

  bool get _replyBySender => message.replyMessage.replyBy == sender.id;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final replyMessage = message.replyMessage.message;
    final replyBy = _replyBySender ? PackageStrings.you : receiver.name;
    return Container(
      margin: repliedMessageConfig?.margin ??
          const EdgeInsets.only(
            right: horizontalPadding,
            left: horizontalPadding,
            bottom: 4,
          ),
      constraints:
          BoxConstraints(maxWidth: repliedMessageConfig?.maxWidth ?? 280),
      child: Column(
        crossAxisAlignment:
            _replyBySender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            "${PackageStrings.repliedBy} $replyBy",
            style: repliedMessageConfig?.replyTitleTextStyle ??
                textTheme.bodyText2!.copyWith(fontSize: 14, letterSpacing: 0.3),
          ),
          const SizedBox(height: 6),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: _replyBySender
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                if (!_replyBySender)
                  VerticalLine(
                    verticalBarWidth: repliedMessageConfig?.verticalBarWidth,
                    verticalBarColor: repliedMessageConfig?.verticalBarColor,
                    rightPadding: 4,
                  ),
                Flexible(
                  child: Opacity(
                    opacity: repliedMessageConfig?.opacity ?? 0.8,
                    child: replyMessage.isImageUrl
                        ? Container(
                            height: repliedMessageConfig
                                    ?.repliedImageMessageHeight ??
                                100,
                            width: repliedMessageConfig
                                    ?.repliedImageMessageWidth ??
                                80,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(replyMessage),
                                fit: BoxFit.fill,
                              ),
                              borderRadius:
                                  repliedMessageConfig?.borderRadius ??
                                      BorderRadius.circular(14),
                            ),
                          )
                        : Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    repliedMessageConfig?.maxWidth ?? 280),
                            padding: repliedMessageConfig?.padding ??
                                const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: _borderRadius(replyMessage),
                              color: repliedMessageConfig?.backgroundColor ??
                                  Colors.grey.shade500,
                            ),
                            child: Text(
                              replyMessage,
                              style: repliedMessageConfig?.textStyle ??
                                  textTheme.bodyText2!
                                      .copyWith(color: Colors.black),
                            ),
                          ),
                  ),
                ),
                if (_replyBySender)
                  VerticalLine(
                    verticalBarWidth: repliedMessageConfig?.verticalBarWidth,
                    verticalBarColor: repliedMessageConfig?.verticalBarColor,
                    leftPadding: 4,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BorderRadiusGeometry _borderRadius(String replyMessage) => _replyBySender
      ? repliedMessageConfig?.borderRadius ??
          (replyMessage.length < 37
              ? BorderRadius.circular(replyBorderRadius1)
              : BorderRadius.circular(replyBorderRadius2))
      : repliedMessageConfig?.borderRadius ??
          (replyMessage.length < 29
              ? BorderRadius.circular(replyBorderRadius1)
              : BorderRadius.circular(replyBorderRadius2));
}

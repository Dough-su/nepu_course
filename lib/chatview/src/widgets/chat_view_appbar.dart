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
import 'dart:io' if (kIsWeb) 'dart:html';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';

import '../values/typedefs.dart';

class ChatViewAppBar extends StatelessWidget {
  const ChatViewAppBar({
    Key? key,
    this.backGroundColor,
    this.title,
    this.userStatus,
    this.profilePicture,
    this.titleTextStyle,
    this.userStatusTextStyle,
    this.backArrowColor,
    this.actions,
    this.elevation,
    this.onBackPress,
  }) : super(key: key);
  final Color? backGroundColor;
  final String? title;
  final String? userStatus;
  final String? profilePicture;
  final TextStyle? titleTextStyle;
  final TextStyle? userStatusTextStyle;
  final Color? backArrowColor;
  final List<Widget>? actions;
  final double? elevation;
  final VoidCallBack? onBackPress;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation ?? 1,
      child: Container(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 4),
        color: backGroundColor ?? Colors.white,
        child: Row(
          children: [
            IconButton(
              onPressed: onBackPress ?? () => Navigator.pop(context),
              icon: Icon(
                (!kIsWeb && Platform.isIOS)
                    ? Icons.arrow_back_ios
                    : Icons.arrow_back,
                color: backArrowColor,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  if (profilePicture != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                          backgroundImage: NetworkImage(profilePicture!)),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          style: titleTextStyle ??
                              const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.25,
                              ),
                        ),
                      if (userStatus != null)
                        Text(
                          userStatus!,
                          style: userStatusTextStyle,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (actions != null) ...actions!,
          ],
        ),
      ),
    );
  }
}

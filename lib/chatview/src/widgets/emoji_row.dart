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
import 'package:muse_nepu_course/chatview/src/models/reaction_popup_configuration.dart';
import 'package:muse_nepu_course/chatview/src/utils/constants.dart';

import '../values/typedefs.dart';
import 'emoji_picker_widget.dart';

class EmojiRow extends StatelessWidget {
  EmojiRow({
    Key? key,
    required this.onEmojiTap,
    this.emojiConfiguration,
  }) : super(key: key);

  final StringCallback onEmojiTap;
  final EmojiConfiguration? emojiConfiguration;
  final List<String> _emojiUnicodes = [
    heart,
    faceWithTears,
    astonishedFace,
    disappointedFace,
    angryFace,
    thumbsUp,
  ];

  @override
  Widget build(BuildContext context) {
    final emojiList = emojiConfiguration?.emojiList ?? _emojiUnicodes;
    final size = emojiConfiguration?.size;
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              emojiList.length,
              (index) => GestureDetector(
                onTap: () => onEmojiTap(emojiList[index]),
                child: Text(
                  emojiList[index],
                  style: TextStyle(fontSize: size ?? 28),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          constraints: const BoxConstraints(),
          icon: Icon(
            Icons.add,
            color: Colors.grey.shade600,
            size: size ?? 28,
          ),
          onPressed: () => _showBottomSheet(context),
        ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context) => showModalBottomSheet<void>(
        context: context,
        builder: (context) => EmojiPickerWidget(onSelected: (emoji) {
          Navigator.pop(context);
          onEmojiTap(emoji);
        }),
      );
}

import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'dart:io';

class EmojiSelectionDrawer extends StatelessWidget {
  final TextEditingController mess;
  const EmojiSelectionDrawer({Key? key, required this.mess}) : super(key: key);

  _onEmojiSelected(Emoji emoji) {
    mess
      ..text += emoji.emoji
      ..selection =
          TextSelection.fromPosition(TextPosition(offset: mess.text.length));
  }

  _onBackspacePressed() {
    mess
      ..text = mess.text.characters.skipLast(1).toString()
      ..selection =
          TextSelection.fromPosition(TextPosition(offset: mess.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return EmojiPicker(
      onEmojiSelected: (Category category, Emoji emoji) {
        _onEmojiSelected(emoji);
      },
      onBackspacePressed: _onBackspacePressed,
      config: Config(
          columns: 7,
          // Issue: https://github.com/flutter/flutter/issues/28894
          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
          verticalSpacing: 0,
          horizontalSpacing: 0,
          initCategory: Category.RECENT,
          bgColor: const Color(0xFFF2F2F2),
          indicatorColor: Colors.blue,
          iconColor: Colors.grey,
          iconColorSelected: Colors.blue,
          progressIndicatorColor: Colors.blue,
          backspaceColor: Colors.blue,
          showRecentsTab: true,
          recentsLimit: 28,
          noRecentsText: 'No Recents',
          noRecentsStyle: const TextStyle(fontSize: 20, color: Colors.black26),
          tabIndicatorAnimDuration: kTabScrollDuration,
          categoryIcons: const CategoryIcons(),
          buttonMode: ButtonMode.MATERIAL),
    );
  }
}

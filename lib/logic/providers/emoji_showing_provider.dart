import 'package:flutter/foundation.dart';

class EmojiShowing extends ChangeNotifier {
  bool emojiShowing = false;

  void changeToTrue() {
    emojiShowing = true;
    notifyListeners();
  }

  void changeToFalse() {
    emojiShowing = false;
    notifyListeners();
  }

  void flip() {
    emojiShowing = !emojiShowing;
    notifyListeners();
  }
}

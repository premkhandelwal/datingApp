import 'package:flutter/foundation.dart';

class ChatAudioPlayer extends ChangeNotifier {
  bool isPlaying = false;

  void changeToTrue() {
    isPlaying = true;
    notifyListeners();
  }

  void changeToFalse() {
    isPlaying = false;
    notifyListeners();
  }
}

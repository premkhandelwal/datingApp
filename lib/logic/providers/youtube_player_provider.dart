import 'package:flutter/foundation.dart';

class IsPlaying extends ChangeNotifier {
  bool isPlaying = false;
  String id = "";

  bool changeToTrue() {
    isPlaying = true;
    notifyListeners();
    return isPlaying;
  }

  bool changeToFalse() {
    isPlaying = false;
    notifyListeners();
    return isPlaying;
  }

  void getId(String yid) {
    id = yid;
  }
}

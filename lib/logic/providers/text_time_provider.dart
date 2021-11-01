import 'package:flutter/foundation.dart';

class IsExpanded extends ChangeNotifier {
  bool isExpanded = false;

  bool changeToTrue() {
    isExpanded = true;
    notifyListeners();
    return isExpanded;
  }

  bool changeToFalse() {
    isExpanded = false;
    notifyListeners();
    return isExpanded;
  }
}

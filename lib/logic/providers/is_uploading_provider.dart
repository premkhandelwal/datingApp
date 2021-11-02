import 'package:flutter/foundation.dart';

class IsUpLoading extends ChangeNotifier {
  bool isUpLoading = false;

  void changeToTrue() {
    isUpLoading = true;
    notifyListeners();
  }

  void changeToFalse() {
    isUpLoading = false;
    notifyListeners();
  }
}

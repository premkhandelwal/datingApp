import 'package:flutter/foundation.dart';

class RecordingProvider extends ChangeNotifier {
  bool recordingSelected = false;
  bool isRecording = false;
  bool isRecordingPlaying = false;
  bool isRecorded = false;
  bool isPlaying = false;

  void changeRecordingSelected() {
    recordingSelected = !recordingSelected;
    notifyListeners();
  }

  void changeIsRecording() {
    isRecording = !isRecording;
    notifyListeners();
  }

  void changeIsRecordingPlaying() {
    isRecordingPlaying = !isRecordingPlaying;
    notifyListeners();
  }

  void changeIsRecorded() {
    isRecorded = !isRecorded;
    notifyListeners();
  }

  void changeIsPlaying() {
    isPlaying = !isPlaying;
    notifyListeners();
  }

  void resetAllValues() {
    recordingSelected = false;
    isRecording = false;
    isRecordingPlaying = false;
    isRecorded = false;
    isPlaying = false;
    notifyListeners();
  }
}

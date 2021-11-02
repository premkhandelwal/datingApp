// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dating_app/services/sound_player.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialised = false;

  Future init() async {
    _audioRecorder = FlutterSoundRecorder();

    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      print("this is an error");
    }

    await _audioRecorder!.openAudioSession();
    _isRecorderInitialised = true;
  }

  void dispose() {
    _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    _isRecorderInitialised = false;
  }

  Future _record() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    pathToReadAudio = '${appDocDir.path}/recorded_audio.aac';
    if (!_isRecorderInitialised) return;
    await _audioRecorder!
        .startRecorder(toFile: pathToReadAudio, codec: Codec.aacMP4);
  }

  Future _stop() async {
    if (!_isRecorderInitialised) return;
    await _audioRecorder!.stopRecorder();
  }

  Future toggleRecording() async {
    if (_audioRecorder!.isStopped) {
      await _record();
    } else {
      await _stop();
    }
  }
}

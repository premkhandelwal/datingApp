import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/flutter_sound.dart';

String pathToReadAudio = "";
late File audioFile;

class SoundPlayer {
  FlutterSoundPlayer? _audioPlayer;

  Future init() async {
    _audioPlayer = FlutterSoundPlayer();

    await _audioPlayer!.openAudioSession();
  }

  void dispose() {
    _audioPlayer!.closeAudioSession();
    _audioPlayer = null;
  }

  Future _play(VoidCallback whenFinished) async {
    audioFile = File(pathToReadAudio);
    await _audioPlayer!
        .startPlayer(fromURI: pathToReadAudio, whenFinished: whenFinished);
  }

  Future _stop() async {
    await _audioPlayer!.stopPlayer();
  }

  Future togglePlaying({required VoidCallback whenFinished}) async {
    if (_audioPlayer!.isStopped) {
      await _play(whenFinished);
    } else {
      await _stop();
    }
  }
}

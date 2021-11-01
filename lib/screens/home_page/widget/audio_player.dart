import 'package:audioplayers/audioplayers.dart';
import 'package:dating_app/logic/providers/audio_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAudioPlayer extends StatefulWidget {
  final String audioLink;
  const MyAudioPlayer({Key? key, required this.audioLink}) : super(key: key);

  @override
  _MyAudioPlayerState createState() => _MyAudioPlayerState();
}

class _MyAudioPlayerState extends State<MyAudioPlayer> {
  late AudioPlayer audioPlayer;
  @override
  void initState() {
    audioPlayer = AudioPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        constraints: BoxConstraints.loose(const Size(250, 50)),
        child: ListTile(
          leading: Provider.of<ChatAudioPlayer>(context).isPlaying == true
              ? const Icon(
                  Icons.pause,
                  size: 40,
                )
              : const Icon(
                  Icons.play_arrow,
                  size: 40,
                ),
          title: const Text("Audio File"),
          onTap: () async {
            Provider.of<ChatAudioPlayer>(context, listen: false).changeToTrue();
            await audioPlayer.play(widget.audioLink, isLocal: false);
            audioPlayer.onPlayerCompletion.listen((event) {
              Provider.of<ChatAudioPlayer>(context, listen: false)
                  .changeToFalse();
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}

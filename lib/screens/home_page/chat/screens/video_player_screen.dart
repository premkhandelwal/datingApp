import 'package:dating_app/arguments/video_player_screen_args.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  static const routeName = '/videoPlayerScreen';
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerScreenArguments args;

  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    args = ModalRoute.of(context)!.settings.arguments
        as VideoPlayerScreenArguments;
    flickManager = FlickManager(
      autoPlay: false,
      videoPlayerController: VideoPlayerController.network(args.url),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Video Player'),
      ),
      body: FlickVideoPlayer(
        flickVideoWithControls: const FlickVideoWithControls(
          controls: FlickPortraitControls(),
          videoFit: BoxFit.contain,
        ),
        flickVideoWithControlsFullscreen: const FlickVideoWithControls(
          controls: FlickPortraitControls(),
          videoFit: BoxFit.contain,
        ),
        flickManager: flickManager,
      ),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }
}

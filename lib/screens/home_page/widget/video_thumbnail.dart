import 'dart:io';

import 'package:dating_app/arguments/video_player_screen_args.dart';
import 'package:dating_app/screens/home_page/chat/screens/video_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class VideoThumbNail extends StatelessWidget {
  final String videoUrl;
  const VideoThumbNail({Key? key, required this.videoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.loose(const Size(250, 445)),
      color: Colors.black,
      child: Stack(children: [
        FutureBuilder<String?>(
            future: getThumbnail(videoUrl),
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: Image.file(
                    File(snapshot.data!),
                    fit: BoxFit.fill,
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            }),
        Center(
          child: IconButton(
            icon: const Icon(Icons.play_circle_fill,
                color: Colors.white, size: 45),
            onPressed: () {
              Navigator.pushNamed(context, VideoPlayerScreen.routeName,
                  arguments: VideoPlayerScreenArguments(videoUrl));
            },
          ),
        ),
      ]),
    );
  }
}

Future<String?> getThumbnail(String url) async {
  String? fileName = await VideoThumbnail.thumbnailFile(
    video: url,
    thumbnailPath: (await getTemporaryDirectory()).path,
    imageFormat: ImageFormat.PNG,
    maxWidth:
        250, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    quality: 100,
  );
  return fileName;
}

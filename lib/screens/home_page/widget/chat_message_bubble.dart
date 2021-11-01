import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/logic/data/message.dart';
import 'package:dating_app/logic/providers/audio_player_provider.dart';
import 'package:dating_app/logic/providers/text_time_provider.dart';
import 'package:dating_app/logic/providers/youtube_player_provider.dart';
import 'package:dating_app/screens/home_page/widget/audio_player.dart';
import 'package:dating_app/screens/home_page/widget/video_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clipboard/clipboard.dart';

class ChatMessage extends StatefulWidget {
  final Message message;
  final dynamic args;
  const ChatMessage({Key? key, required this.message, required this.args})
      : super(key: key);
  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  late bool isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isExpanded = Provider.of<IsExpanded>(context).isExpanded;
    double lrEdgeInsets = 3;
    double tbEdgeInsets = 3;

    if (widget.message is TextMessage) {
      lrEdgeInsets = 8;
      tbEdgeInsets = 8;
    }
    return ChangeNotifierProvider<ChatAudioPlayer>(
      create: (context) => ChatAudioPlayer(),
      child: widget.message is TextMessage
          ? GestureDetector(
              onTap: () {
                if (isExpanded) {
                  Provider.of<IsExpanded>(context, listen: false)
                      .changeToFalse();
                } else {
                  Provider.of<IsExpanded>(context, listen: false)
                      .changeToTrue();
                }
              },
              child: Bubble(
                color: (widget.message.to == widget.args.userId!
                    ? Colors.grey[500]
                    : Colors.blue[200]),
                alignment: widget.message.from != widget.args.userId!
                    ? Alignment.topRight
                    : Alignment.topLeft,
                nip: widget.message.from != widget.args.userId!
                    ? BubbleNip.rightTop
                    : BubbleNip.leftTop,
                radius: const Radius.circular(12),
                padding: BubbleEdges.symmetric(
                    horizontal: lrEdgeInsets, vertical: tbEdgeInsets),
                margin:
                    const BubbleEdges.symmetric(vertical: 3, horizontal: 15),
                child: buildMessageContent(widget.message, context),
              ),
            )
          : Bubble(
              color: (widget.message.to == widget.args.userId!
                  ? Colors.grey[500]
                  : Colors.blue[200]),
              alignment: widget.message.from != widget.args.userId!
                  ? Alignment.topRight
                  : Alignment.topLeft,
              nip: widget.message.from != widget.args.userId!
                  ? BubbleNip.rightTop
                  : BubbleNip.leftTop,
              radius: const Radius.circular(12),
              padding: BubbleEdges.symmetric(
                  horizontal: lrEdgeInsets, vertical: tbEdgeInsets),
              margin: const BubbleEdges.symmetric(vertical: 3, horizontal: 15),
              child: buildMessageContent(widget.message, context),
            ),
    );
  }

  buildMessageContent(Message message, BuildContext context) {
    if (message is TextMessage) {
      return InkWell(
        onTap: () {
          if (isExpanded) {
            Provider.of<IsExpanded>(context, listen: false).changeToFalse();
          } else {
            Provider.of<IsExpanded>(context, listen: false).changeToTrue();
          }
        },
        onLongPress: () {
          const snackBar = SnackBar(
              duration: Duration(seconds: 3),
              content: Text('Link copied to Clipboard'));
          FlutterClipboard.copy(message.message).then(
              (value) => ScaffoldMessenger.of(context).showSnackBar(snackBar));
        },
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Linkify(
            options: const LinkifyOptions(looseUrl: true),
            onOpen: (link) async {
              if (link.url.contains('youtu')) {
                String yid = getYoutubeVideoId(link.url);
                Provider.of<IsPlaying>(context, listen: false).changeToTrue();
                Provider.of<IsPlaying>(context, listen: false).getId(yid);
              } else if (await canLaunch(link.url)) {
                await launch(link.url);
              } else {
                throw 'Could not launch $link';
              }
            },
            text: message.message,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      );
    } else if (message is ImageMessage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: BoxConstraints.loose(const Size(250, 445)),
          child: CachedNetworkImage(
            imageUrl: message.imageUrl,
            fit: BoxFit.contain,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
                    child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress))),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      );
    } else if (message is VideoMessage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: VideoThumbNail(
          videoUrl: message.videoUrl,
        ),
      );
    } else if (message is GifMessage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: BoxConstraints.loose(const Size(250, 250)),
          child: Image.network(
            message.gifUrl,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;

              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.contain,
            headers: const {'accept': 'image/*'},
          ),
        ),
      );
    } else if (message is DocumentMessage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: BoxConstraints.loose(const Size(250, 50)),
          child: ListTile(
            leading: const Icon(
              Icons.file_present_sharp,
              size: 40,
            ),
            title: Text(message.sendTime.toString()),
            onTap: () async {
              if (await canLaunch(message.docUrl)) {
                await launch(message.docUrl);
              } else {
                throw 'Could not launch ${message.docUrl}';
              }
            },
          ),
        ),
      );
    } else if (message is AudioMessage) {
      return MyAudioPlayer(audioLink: message.audioUrl);
    }
  }

  String getYoutubeVideoId(String url) {
    RegExp regExp = RegExp(
      r'.*(?:(?:youtu\.be\/|v\/|vi\/|u\/\w\/|embed\/)|(?:(?:watch)?\?v(?:i)?=|\&v(?:i)?=))([^#\&\?]*).*',
      caseSensitive: false,
      multiLine: false,
    );
    final String? match =
        regExp.firstMatch(url)!.group(1); // <- This is the fix
    String str = match!;
    return str;
  }
}

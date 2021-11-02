import 'package:dating_app/arguments/chat_screen_arguments.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/logic/data/message.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/logic/providers/emoji_showing_provider.dart';
import 'package:dating_app/logic/providers/recording_provider.dart';
import 'package:dating_app/screens/home_page/widget/send_media._button.dart';
import 'package:dating_app/screens/home_page/widget/show_alert.dart';
import 'package:dating_app/services/db_services.dart';
import 'package:dating_app/services/sound_player.dart';
import 'package:dating_app/services/sound_recorder.dart';
import 'package:dating_app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:provider/provider.dart';

class ChatBox extends StatefulWidget {
  final ChatScreenArguments args;
  final TextEditingController mess;
  const ChatBox({Key? key, required this.args, required this.mess})
      : super(key: key);

  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  late DbServices db;
  CurrentUser? currentUser;
  final recorder = SoundRecorder();
  final player = SoundPlayer();
  Duration duration = const Duration();

  @override
  void initState() {
    db = DbServices();
    recorder.init();
    player.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentUser = SessionConstants.sessionUser;
    return Card(
      child: Container(
        padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
        height: 60,
        width: double.infinity,
        child: Provider.of<RecordingProvider>(context).recordingSelected
            ? recordingRow()
            : messageRow(),
      ),
    );
  }

  Widget recordingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Provider.of<RecordingProvider>(
          context,
        ).isRecorded
            ? Provider.of<RecordingProvider>(context).isPlaying
                ? const Text(
                    "Playing",
                    style: TextStyle(fontSize: 14, color: Colors.pink),
                  )
                : IconButton(
                    onPressed: () async {
                      await player.togglePlaying(whenFinished: () {
                        Provider.of<RecordingProvider>(context, listen: false)
                            .changeIsPlaying();
                      });
                      Provider.of<RecordingProvider>(context, listen: false)
                          .changeIsPlaying();
                    },
                    icon: const Icon(Icons.play_arrow))
            : Provider.of<RecordingProvider>(context).isRecording
                ? const Text(
                    "Recording",
                    style: TextStyle(fontSize: 14, color: Colors.pink),
                  )
                : IconButton(
                    onPressed: () async {
                      await recorder.toggleRecording();
                      Provider.of<RecordingProvider>(context, listen: false)
                          .changeIsRecording();
                    },
                    icon: const Icon(Icons.mic)),
        IconButton(
            onPressed: () async {
              if (Provider.of<RecordingProvider>(context, listen: false)
                      .isRecorded &&
                  Provider.of<RecordingProvider>(context, listen: false)
                      .isPlaying) {
                Provider.of<RecordingProvider>(context, listen: false)
                    .changeIsPlaying();
                await player.togglePlaying(whenFinished: () {
                  Provider.of<RecordingProvider>(context, listen: false)
                      .changeIsPlaying();
                });
              } else if (!Provider.of<RecordingProvider>(context, listen: false)
                      .isRecorded &&
                  Provider.of<RecordingProvider>(context, listen: false)
                      .isRecording) {
                Provider.of<RecordingProvider>(context, listen: false)
                    .changeIsRecorded();
                Provider.of<RecordingProvider>(context, listen: false)
                    .changeIsRecording();
                await recorder.toggleRecording();
              }
            },
            icon: const Icon(Icons.stop)),
        IconButton(
            onPressed: () {
              if (Provider.of<RecordingProvider>(context, listen: false)
                  .isRecorded) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ShowAlert(
                          title: "Warning",
                          content:
                              "Are you sure you want to record audio again?",
                          successFunction: () {
                            Provider.of<RecordingProvider>(context,
                                    listen: false)
                                .changeIsRecorded();

                            if (Provider.of<RecordingProvider>(context,
                                    listen: false)
                                .isPlaying) {
                              Provider.of<RecordingProvider>(context,
                                      listen: false)
                                  .changeIsPlaying();
                            }
                            Navigator.pop(context);
                          });
                    });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("There is no recorded audio")));
              }
            },
            icon: const Icon(Icons.restore)),
        IconButton(
          onPressed: () async {
            if (Provider.of<RecordingProvider>(context, listen: false)
                .isRecorded) {
              Provider.of<RecordingProvider>(context, listen: false)
                  .resetAllValues();
              StorageServices st = StorageServices();
              st.uploadDoc(
                  widget.args.chatid,
                  AudioMessage("", DateTime.now().toString(), currentUser!.uid,
                      widget.args.user!.uid),
                  audioFile,
                  context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please record some audio to upload")));
            }
          },
          icon: const Icon(Icons.upload),
        ),
        IconButton(
          onPressed: () {
            if (Provider.of<RecordingProvider>(context, listen: false)
                .isRecorded) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ShowAlert(
                        title: "warning",
                        content: "Are you sure you want to cancel recording?",
                        successFunction: () {
                          if (Provider.of<RecordingProvider>(context,
                                  listen: false)
                              .isPlaying) {
                            player.togglePlaying(whenFinished: () {
                              Provider.of<RecordingProvider>(context,
                                      listen: false)
                                  .changeIsPlaying();
                            });
                          }
                          Provider.of<RecordingProvider>(context, listen: false)
                              .resetAllValues();
                          Navigator.pop(context);
                        });
                  });
            } else {
              if (Provider.of<RecordingProvider>(context, listen: false)
                  .isRecording) {
                recorder.toggleRecording();
              }
              Provider.of<RecordingProvider>(context, listen: false)
                  .resetAllValues();
            }
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
        )
      ],
    );
  }

  Widget messageRow() {
    return Row(
      children: <Widget>[
        SendMediaButton(args: widget.args, currentUser: currentUser),
        IconButton(
          onPressed: () {
            Provider.of<EmojiShowing>(context, listen: false).flip();
            FocusScope.of(context).unfocus();
          },
          padding: const EdgeInsets.only(top: 3),
          icon: const Icon(
            Icons.emoji_emotions,
            size: 30,
            color: Colors.pink,
          ),
        ),
        IconButton(
          onPressed: () async {
            GiphyGif? _gif = await GiphyPicker.pickGif(
              context: context,
              apiKey: 'mJm5RBWLPzAWzcTR7KJLbk9bPQwUQmwB',
              fullScreenDialog: false,
              previewType: GiphyPreviewType.previewWebp,
              decorator: GiphyDecorator(
                showAppBar: false,
                searchElevation: 4,
                giphyTheme: ThemeData.dark().copyWith(
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            );
            if (_gif != null) {
              db.sendMessage(
                widget.args.chatid,
                GifMessage(
                  _gif.images.original!.url!,
                  DateTime.now().toString(),
                  currentUser!.uid,
                  widget.args.user!.uid,
                ),
              );
            }
          },
          padding: const EdgeInsets.only(bottom: 5),
          icon: const Icon(
            Icons.gif_sharp,
            size: 45,
            color: Colors.pink,
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: TextField(
            onTap: () {
              Provider.of<EmojiShowing>(context, listen: false).changeToFalse();
            },
            decoration: const InputDecoration(
                hintText: "Write message...", border: InputBorder.none),
            controller: widget.mess,
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        IconButton(
          padding: const EdgeInsets.only(bottom: 4),
          onPressed: () async {
            if (widget.mess.text != "") {
              db.sendMessage(
                widget.args.chatid,
                TextMessage(
                  widget.mess.text,
                  DateTime.now().toString(),
                  currentUser!.uid,
                  widget.args.user!.uid,
                ),
              );
            }
            widget.mess.clear();
          },
          icon: const Icon(
            Icons.send,
            color: Colors.pink,
            size: 24,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    recorder.dispose();
    player.dispose();
    super.dispose();
  }
}

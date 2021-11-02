import 'dart:io';

import 'package:dating_app/arguments/chat_screen_arguments.dart';
import 'package:dating_app/logic/data/message.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:dating_app/logic/providers/recording_provider.dart';
import 'package:dating_app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SendMediaButton extends StatelessWidget {
  final ChatScreenArguments args;
  final CurrentUser? currentUser;
  const SendMediaButton(
      {Key? key, required this.args, required this.currentUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    StorageServices st = StorageServices();
    return PopupMenuButton(
        elevation: 20,
        enabled: true,
        onSelected: (value) async {
          if (value == "Camera Photo") {
            XFile? photo = await st.pickCameraPhoto();
            st.uploadMedia(
                args.chatid,
                ImageMessage(
                    "", DateTime.now().toString(), currentUser!.uid, args.user),
                photo,
                context);
          } else if (value == "Camera Video") {
            XFile? photo = await st.pickCameraVideo();
            st.uploadMedia(
                args.chatid,
                VideoMessage(
                    "", DateTime.now().toString(), currentUser!.uid, args.user),
                photo,
                context);
          } else if (value == "Gallery Photo") {
            XFile? photo = await st.pickGalleryPhoto();
            st.uploadMedia(
                args.chatid,
                ImageMessage(
                    "", DateTime.now().toString(), currentUser!.uid, args.user),
                photo,
                context);
          } else if (value == "Gallery Video") {
            XFile? photo = await st.pickGalleryVideo();
            st.uploadMedia(
                args.chatid,
                VideoMessage(
                    "", DateTime.now().toString(), currentUser!.uid, args.user),
                photo,
                context);
          } else if (value == "Record Audio") {
            Provider.of<RecordingProvider>(context, listen: false)
                .changeRecordingSelected();
          } else if (value == "Document") {
            File? doc = await st.pickDoc();
            st.uploadDoc(
                args.chatid,
                DocumentMessage(
                    "", DateTime.now().toString(), currentUser!.uid, args.user),
                doc,
                context);
          }
        },
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: Colors.pink,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 20,
          ),
        ),
        itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text("Camera Photo"),
                value: "Camera Photo",
              ),
              const PopupMenuItem(
                child: Text("Camera Video"),
                value: "Camera Video",
              ),
              const PopupMenuItem(
                child: Text("Gallery Photo"),
                value: "Gallery Photo",
              ),
              const PopupMenuItem(
                child: Text("Gallery Video"),
                value: "Gallery Video",
              ),
              const PopupMenuItem(
                child: Text("Record Audio"),
                value: "Record Audio",
              ),
              const PopupMenuItem(
                child: Text("Document"),
                value: "Document",
              ),
            ]);
  }
}

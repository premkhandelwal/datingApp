// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dating_app/logic/data/message.dart';
import 'package:dating_app/logic/providers/is_uploading_provider.dart';
import 'package:dating_app/services/db_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class StorageServices {
  Future<XFile?> pickCameraPhoto() async {
    final picker = ImagePicker();
    XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 10);
    return pickedFile;
  }

  Future<File?> pickDoc() async {
    File? file;
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path!);
    }
    return file;
  }

  Future<XFile?> pickCameraVideo() async {
    final picker = ImagePicker();
    XFile? pickedFile = await picker.pickVideo(
        source: ImageSource.camera, maxDuration: const Duration(minutes: 1));
    return pickedFile;
  }

  Future<XFile?> pickGalleryPhoto() async {
    final picker = ImagePicker();
    XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 10);
    return pickedFile;
  }

  Future<XFile?> pickGalleryVideo() async {
    final picker = ImagePicker();
    XFile? pickedFile = await picker.pickVideo(
        source: ImageSource.gallery, maxDuration: const Duration(minutes: 1));
    return pickedFile;
  }

  Future<void> uploadMedia(
      String chatid, Message message, XFile? uri, BuildContext context) async {
    DbServices db = DbServices();
    if (uri != null) {
      Provider.of<IsUpLoading>(context, listen: false).changeToTrue();
      File file = File(uri.path);
      try {
        if (message is ImageMessage) {
          await firebase_storage.FirebaseStorage.instance
              .ref('$chatid/${message.from}/${message.sendTime}')
              .putFile(file);
          String url = await firebase_storage.FirebaseStorage.instance
              .ref('$chatid/${message.from}/${message.sendTime}')
              .getDownloadURL();
          message.imageUrl = url;
          await db.sendMessage(
            chatid,
            message,
          );
        } else if (message is VideoMessage) {
          await firebase_storage.FirebaseStorage.instance
              .ref('$chatid/${message.from}/${message.sendTime}')
              .putFile(file);
          String url = await firebase_storage.FirebaseStorage.instance
              .ref('$chatid/${message.from}/${message.sendTime}')
              .getDownloadURL();
          message.videoUrl = url;
          await db.sendMessage(
            chatid,
            message,
          );
        }
      } on firebase_core.FirebaseException catch (e) {
        print(e.message);
      }
      Provider.of<IsUpLoading>(context, listen: false).changeToFalse();
    }
  }

  Future<void> uploadDoc(
      String chatid, Message message, File? uri, BuildContext context) async {
    DbServices db = DbServices();
    if (uri != null) {
      Provider.of<IsUpLoading>(context, listen: false).changeToTrue();
      File file = File(uri.path);
      try {
        if (message is DocumentMessage) {
          await firebase_storage.FirebaseStorage.instance
              .ref('$chatid/${message.from}/${message.sendTime}')
              .putFile(file);
          String url = await firebase_storage.FirebaseStorage.instance
              .ref('$chatid/${message.from}/${message.sendTime}')
              .getDownloadURL();
          message.docUrl = url;
          await db.sendMessage(
            chatid,
            message,
          );
        } else if (message is AudioMessage) {
          await firebase_storage.FirebaseStorage.instance
              .ref('$chatid/${message.from}/${message.sendTime}')
              .putFile(file);
          String url = await firebase_storage.FirebaseStorage.instance
              .ref('$chatid/${message.from}/${message.sendTime}')
              .getDownloadURL();
          message.audioUrl = url;
          await db.sendMessage(
            chatid,
            message,
          );
        }
      } on firebase_core.FirebaseException catch (e) {
        print(e.message);
      }
      Provider.of<IsUpLoading>(context, listen: false).changeToFalse();
    }
  }
}

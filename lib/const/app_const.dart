import 'dart:io';

import 'package:dating_app/logic/data/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

class SessionConstants {
  static List<CurrentUser> allUsers = [];
  static const sessionUid = "sessionUid";
  static const sessionUsername = 'sessionUsername';
  static const sessionSignedInWith = "sessionSignedInWith";

  static CurrentUser sessionUser = CurrentUser(); //[phone Number, email]

  static void clear() {
    sessionUser = CurrentUser();
    allUsers = [];
  }
  // statsic const profileImage
}

const Color AppColor = Color(0xffE94057);
enum GENDER { NotSelected, male, female, other }
enum INTERESTEDIN { Male, Female, Both }

Future<File> urlToFile(String imageUrl, String? uid) async {
  try {
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath' + "$uid" + '.jpeg');
    Uri uri = Uri.parse(imageUrl);
    http.Response response = await http.get(uri);
    await file
        .writeAsBytes(response.bodyBytes)
        .catchError((e) => throw Exception(e));
    return file;
  } catch (e) {
    throw Exception(e);
  }
}

bool isImage(String path) {
  final mimeType = lookupMimeType(path);
  if (mimeType != null) {
    return mimeType.startsWith('image/');
  }
  return false;
}

int calculateAge(DateTime birthDate) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}

void changePageTo({required BuildContext context, required Widget widget}) {
  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => widget));
}

void changePageWithoutBack(
    {required BuildContext context, required Widget widget}) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (ctx) => widget), (route) => false);
}

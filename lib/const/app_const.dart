import 'dart:io';
import 'package:dating_app/logic/data/appliedFilters.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart';

class SessionConstants {
  static AppliedFilters? appliedFilters = AppliedFilters(
      maxAge: 0, minAge: 0, interestedIn: GENDER.NotSelected, thresholdDist: 0);
  static AppliedFilters? defaultFilters;
  static const sessionUid = "sessionUid";
  static const sessionUsername = 'sessionUsername';
  static const sessionSignedInWith = "sessionSignedInWith";

  static CurrentUser sessionUser = CurrentUser(); //[phone Number, email]

  static void clear() {
    sessionUser = CurrentUser();
    appliedFilters = AppliedFilters(
        maxAge: 0,
        minAge: 0,
        interestedIn: GENDER.NotSelected,
        thresholdDist: 0);
  }
  // statsic const profileImage
}

const Color AppColor = Color(0xffE94057);
enum GENDER { NotSelected, male, female, other, both }

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

Future<File> assetToFile(Asset assetImage) async {
  final byteData = await assetImage.getByteData(quality: 80);
  final tempFile =
      File("${(await getTemporaryDirectory()).path}/${assetImage.name}");
  final file = await tempFile.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  return file;
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

Future<String> coordinatestoLoc(Map<String, num> coordinates) async {
  if (coordinates["latitude"] != null && coordinates["longitude"] != null) {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        coordinates["latitude"]!.toDouble(),
        coordinates["longitude"]!.toDouble());
    var first = placemarks.first;
    if (first.administrativeArea == null)
      return "${first.subAdministrativeArea}";
    else
      return "${first.subAdministrativeArea}, ${first.administrativeArea}";
  }
  return "";
}

double? calculateDistance(Map<String, num> userLocation) {
  if (userLocation["latitude"] != null && userLocation["longitude"] != null) {
    double distanceInMeters = Geolocator.distanceBetween(
        userLocation["latitude"]!.toDouble(),
        userLocation["longitude"]!.toDouble(),
        SessionConstants.sessionUser.locationCoordinates!["latitude"]!
            .toDouble(),
        SessionConstants.sessionUser.locationCoordinates!["longitude"]!
            .toDouble());
    return distanceInMeters / 1000;
  }
  return null;
}

/* void changePageTo({required BuildContext context, required Widget widget}) {
  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => widget));
}


void changePageWithoutBack(
    {required BuildContext context, required Widget widget}) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (ctx) => widget,
      ),
      (route) => false);
} */

void changePageWithNamedRoutes(
    {required BuildContext context, required String routeName, Object? arguments}) {
  Navigator.of(context).pushNamed(routeName, arguments: arguments);
}

void changePagewithoutBackWithNamedRoutes(
    {required BuildContext context, required String routeName, Object? arguments}) {
  Navigator.of(context).pushNamedAndRemoveUntil(routeName, (route) => false, arguments: arguments);
}

Future<void> imagePopUp(
    {required BuildContext context, required File image}) async {
  await showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              contentPadding: EdgeInsets.all(4.r),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              content: Container(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: InteractiveViewer(
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      /* loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!.toInt()
                                : null,
                          ),
                        );
                      }, */
                      errorBuilder: (context, url, error) => Image.asset(
                        'assets/images/dummy.jpg',
                        height: 75.r,
                        width: 75.r,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 250),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      });
}

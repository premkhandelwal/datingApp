import 'dart:io';
import 'dart:ui';

import 'package:dating_app/const/app_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwipeableSingleCard extends StatelessWidget {
  const SwipeableSingleCard(
      {Key? key,
      required this.imageUrl,
      required this.personName,
      required this.personAge,
      required this.personProfession,
      required this.personDistance})
      : super(key: key);

  final File? imageUrl;
  final String personName, personProfession;
  final int personAge;
  final num? personDistance;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 700.h,
          width: 400.w,
          child: imageUrl != null
              ? Image.file(
                  imageUrl!,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                )
              : Container(
                  color: Colors.amber,
                ),
        ),
        Positioned(
          left: 8.sp,
          top: 8.sp,
          child: Container(
            height: 40.h,
            width: 100.w,
            decoration: BoxDecoration(
                color: AppColor.withOpacity(0.9.sp),
                borderRadius: BorderRadius.circular(10.r)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 18.sp,
                ),
                Text(
                  personDistance != null ? '${personDistance!.toInt()} KM': "-",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Colors.white, fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15.r),
              bottomRight: Radius.circular(15.r),
            ),
            child: Container(
              height: 70.h,
              width: 400.w,
              child: BackdropFilter(
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 8.0.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$personName, $personAge',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Colors.black, fontSize: 24.sp),
                      ),
                      Text(
                        '$personProfession',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                filter: ImageFilter.blur(
                    sigmaX: 70.0.sp, sigmaY: 70.0.sp, tileMode: TileMode.clamp),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

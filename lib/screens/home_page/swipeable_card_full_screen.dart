import 'dart:io';

import 'package:dating_app/arguments/full_screen_image_arguments.dart';
import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/dummy_content/dummy_content.dart';
import 'package:dating_app/screens/home_page/full_screen_image.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:dating_app/widgets/topbar_signup_signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwipeableCardFullScreen extends StatelessWidget {

  const SwipeableCardFullScreen({
    Key? key,
    required this.image,
    required this.personName,
    required this.personBio,
    required this.personProfession,
    required this.personAge,
    required this.swipeLeft,
    required this.swipeRight,
  }) : super(key: key);
  final Function? swipeLeft, swipeRight;
  final File? image;
  final String? personName, personBio, personProfession;
  final int? personAge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: 500.h,
              width: double.infinity,
              child: image != null
                  ? Image.file(
                      image!,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                      errorBuilder: (context, exception, stacktrace) {
                        return Container(
                          color: Colors.amber,
                        );
                      },
                    )
                  : Container(
                      color: Colors.amber,
                    ),
            ),
            ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(20.0.sp),
                  child: CustomAppBar(
                      context: context,
                      centerWidget: Container(),
                      trailingWidget: Container()),
                ),
                SizedBox(height: 280.h),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0.sp, vertical: 20.sp),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.r),
                            topRight: Radius.circular(25.r),
                          )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 40.h),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text('$personName, $personAge',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!),
                                  Text('$personProfession',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!),
                                ],
                              ),
                              IconsOutlinedButton(
                                onPressed: () {},
                                iconSize: 30.sp,
                                size: Size(20.sp, 60.sp),
                                icon: Icons.near_me,
                              )
                            ],
                          ),
                          SizedBox(height: 30.h),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text('Location',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!),
                                  Text('Chicago, IL United States',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!),
                                ],
                              ),
                              Container(
                                height: 40.h,
                                width: 61.w,
                                decoration: BoxDecoration(
                                    color: appColor.withOpacity(0.9),
                                    borderRadius:
                                        BorderRadius.circular(10.r)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                      size: 18.sp,
                                    ),
                                    Text(
                                      '1 KM',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(
                                              color: Colors.white,
                                              fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.h),
                          Text(
                            'Bio',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Text(
                            '$personBio',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          SizedBox(height: 30.h),
                          Text(
                            'Interests',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          SizedBox(
                            height: 100.h,
                            child: GridView.builder(
                              itemCount: interests.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 1,
                                      childAspectRatio: 3 / 1),
                              itemBuilder:
                                  (BuildContext context, int index) {
                                return Row(
                                  children: [
                                    Text(
                                      interests[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2,
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 30.h),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Gallery',
                                style:
                                    Theme.of(context).textTheme.bodyText2,
                              ),
                              Text(
                                'See all',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                        color: appColor,
                                        fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.h),
                          SizedBox(
                            height: 400.h,
                            child: GridView.builder(
                              itemCount: sampleImages.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 2,
                                      crossAxisSpacing: 5,
                                      childAspectRatio: 1),
                              itemBuilder:
                                  (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    changePageWithNamedRoutes(
                                        context: context,
                                        routeName:
                                            FullScreenImage.routeName,
                                        arguments: FullScreenImageArguments(
                                            image: sampleImages,
                                            currentIndex: index));
                                  },
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(15.r),
                                    child: Image.asset(
                                      sampleImages[index],
                                      fit: BoxFit.fitWidth,
                                      alignment: Alignment.topCenter,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -25.sp,
                      left: 50.sp,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 40.r,
                        child: Center(
                          child: IconButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await Future.delayed(
                                    const Duration(milliseconds: 200));
                                swipeLeft!;
                              },
                              iconSize: 60.sp,
                              color: const Color(0xffF27121),
                              icon: const Icon(Icons.close)),
                        ),
                      ),
                    ),
                    Positioned(
                        top: -25.sp,
                        right: 50.sp,
                        child: CircleAvatar(
                          backgroundColor: appColor,
                          radius: 40.r,
                          child: Center(
                            child: IconButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await Future.delayed(
                                      const Duration(milliseconds: 200));
                                  swipeRight!;
                                },
                                iconSize: 60.sp,
                                color: Colors.white,
                                icon: const Icon(Icons.favorite)),
                          ),
                        )),
                  ],
                ),
              ],
            ),
            // Positioned(
            //   top: 10,
            //   left: 10,
            //   child,
            // ),
          ],
        ),
      ),
    );
  }
}

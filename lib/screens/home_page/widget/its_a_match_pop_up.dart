import 'dart:io';

import 'package:dating_app/const/app_const.dart';
import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void itIsAMatchPopUp(BuildContext context, File image,String name) {
  showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: SafeArea(
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                content: Container(
                  height: 600.h,
                  child: Column(
                    children: [
                      Container(
                        height: 360.h,
                        child: Stack(
                          children: [
                            Positioned(
                              right: 20,
                              top: 20,
                              child: Container(
                                height: 240.h,
                                width: 140.w,
                                child: Transform.rotate(
                                  angle: 360 * -10,
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.8),
                                          spreadRadius: 1.r,
                                          blurRadius: 25.r,
                                          offset: Offset(0, 7.sp),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.r),
                                      child:SessionConstants.sessionUser.image != null ? Image.file(
                                         SessionConstants.sessionUser.image!
                                        ,fit: BoxFit.cover,
                                      ):Container(color: Colors.amber,),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 20,
                              bottom: 10,
                              child: Container(
                                height: 240.h,
                                width: 140.w,
                                child: Transform.rotate(
                                  angle: 360 * 10,
                                  alignment: Alignment.center,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.8.sp),
                                          spreadRadius: 1.r,
                                          blurRadius: 25.r,
                                          offset: Offset(0, 7.sp),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.r),
                                      child: Image.file(
                                        image,        
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'It’s a match with $name!',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: AppColor),
                          ),
                        ),
                      ),
                      Text(
                        'Start a conversation now with each other',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      SizedBox(height: 30.h),
                      CommonButton(
                        text: 'Say Hello',
                        onPressed: () {
                          // changePageTo(context: context, widget: );
                        },
                      ),
                      SizedBox(height: 10.h),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          fixedSize: Size(350.sp, 56.sp),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Center(
                          child: Text(
                            'Keep swiping',
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Text('PAGE BUILDER');
      });
}

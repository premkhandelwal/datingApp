import 'package:dating_app/const/app_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final double? textSize;
  final VoidCallback onPressed;
  const CommonButton({Key? key, required this.text, this.textSize,
   required this.onPressed()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(text,style: TextStyle(fontSize: textSize),),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: appColor,
        fixedSize: Size(350.sp, 56.sp),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0.r),
        ),
      ),
    );
  }
}

class IconsOutlinedButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Size size;
  final double iconSize;
  const IconsOutlinedButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.size = const Size(70, 70),
    this.iconSize = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        fixedSize: size,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: onPressed,
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: appColor,
        ),
      ),
    );
  }
}

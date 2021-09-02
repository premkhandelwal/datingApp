import 'package:dating_app/const/app_const.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CommonButton({Key? key, required this.text, required this.onPressed()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(text),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: AppColor,
        fixedSize: Size(350, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}

class IconsOutlinedButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Size size;
  IconsOutlinedButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.size = const Size(70, 70),
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
          color: AppColor,
        ),
      ),
    );
  }
}

import 'package:dating_app/widgets/buttons/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget {
  final bool canGoBack;
  final Widget centerWidget, trailingWidget;
  const CustomAppBar({
    Key? key,
    required BuildContext context,
    this.canGoBack = true,
    required this.centerWidget,
    required this.trailingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (canGoBack)
          SizedBox(
              height: 62.h,
              width: 62.w,
              child: IconsOutlinedButton(
                  icon: Icons.arrow_back,
                  size: Size(52.sp, 52.sp),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })),
        centerWidget,
        SizedBox(height: 62.h, width: 100.w, child: trailingWidget)
      ],
    );
  }
}

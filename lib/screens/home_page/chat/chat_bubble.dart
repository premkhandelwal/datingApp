import 'package:dating_app/const/app_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.isMe,
    required this.message,
    required this.messageTime,
  }) : super(key: key);
  final bool isMe;
  final String message, messageTime;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? Color(0xffF3F3F3) : AppColor.withOpacity(.2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.r),
                  topRight: Radius.circular(15.r),
                  bottomLeft: Radius.circular(!isMe ? 0 : 15.r),
                  bottomRight: Radius.circular(isMe ? 0 : 15.r),
                ),
              ),
              constraints: BoxConstraints(maxWidth: 250.w, minWidth: 0.w),
              padding: EdgeInsets.all(10.sp),
              child: Text(
                message,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Text(
              messageTime,
              style: Theme.of(context).textTheme.subtitle1,
            )
          ],
        ),
      ],
    );
  }
}

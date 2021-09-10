import 'package:dating_app/const/app_const.dart';
import 'package:flutter/material.dart';

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
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(!isMe ? 0 : 15),
                  bottomRight: Radius.circular(isMe ? 0 : 15),
                ),
              ),
              constraints: BoxConstraints(maxWidth: 250, minWidth: 0),
              padding: EdgeInsets.all(10),
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
